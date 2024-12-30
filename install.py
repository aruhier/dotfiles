#!/usr/bin/python3
#
# "Install" all the dotfiles, by making loading the install.conf file in each
# folder and by creating simbolic link at the destination path, targetting the
# source file in the repo
#

import logging
import os
import re
import shutil
import subprocess


def update_git_submodule():
    for opt in ("init", "sync", "update"):
        stdout = subprocess.check_output(["git", "submodule", opt])
        if stdout:
            print(stdout.decode())


def clean_conf_line(line):
    """
    Clean install.conf entries

    :param line: line to clean
    :returns (src, dest): src is the source file path to target, dest is the
                          new symlink path
    :rtype: tuple
    """
    map_path = line.strip().split(":")
    # Remove space or '' or "" around the path
    for i, item in enumerate(map_path):
        map_path[i] = re.sub(r"(^\s*[\"'])|([\"']\s*$)", "", item)
    return map_path


def move_existing_dest(dest):
    """
    If file already exists, move it as dest.old
    """
    logging.debug("File already exists, renaming as .old")
    dest_old = dest + ".old"
    if os.path.isdir(dest_old) and not os.path.islink(dest_old):
        shutil.rmtree(dest_old)
    elif os.path.islink(dest_old):
        os.remove(dest_old)
    shutil.move(dest, dest + ".old")


def create_symlink(path):
    install_conf_path = os.path.join(path, "install.conf")
    if not os.path.isfile(install_conf_path):
        logging.debug("No install.conf for %s", path)
        return
    with open(install_conf_path, "r") as install_conf:
        read_data = install_conf.readlines()
    for line in read_data:
        src, dest = clean_conf_line(line)
        src_path = os.path.abspath(os.path.join(path, src))
        logging.debug("src: %s", src_path)
        logging.debug("dest: %s", dest)

        dest = os.path.expanduser(os.path.expandvars(dest))
        if os.path.abspath(dest) == src_path:
            continue
        if os.path.lexists(dest):
            move_existing_dest(dest)

        if not os.path.isdir(os.path.dirname(dest)):
            os.makedirs(os.path.dirname(dest))
        os.symlink(src_path, dest)

    # launch post_install.sh if any
    post_install = os.path.join(path, "post_install.sh")
    if os.path.exists(post_install):
        stdout = subprocess.check_output(["bash", post_install])
        if stdout:
            print(stdout)


# Enable the debug mode
# logging.basicConfig(level=logging.DEBUG)
os.chdir(os.path.dirname(os.path.realpath(__file__)))
update_git_submodule()
dirs = [child for child in os.listdir() if os.path.isdir(child)]
excluded_dirs = (".git",)
for path in dirs:
    try:
        if path in excluded_dirs:
            logging.debug("%s is in excluded_dirs. Ignoring it...", path)
            continue
        create_symlink(path)
    except Exception as e:
        logging.error("Error during the dotfiles copy in the directory: %s", path)
        logging.exception(e)
