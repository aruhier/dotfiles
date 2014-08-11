#!/usr/bin/python3
# -*- coding: utf-8 -*-
#
# "Install" all the dotfiles, by making loading the install.conf file in each
# folder and by creating simbolic link at the destination path, targetting the
# source file in the repo
#

import logging
import os
import shutil
import subprocess


def update_git_submodule():
    stdout = subprocess.check_output(["git", "submodule", "init"])
    if stdout:
        print(stdout)
    stdout = subprocess.check_output(["git", "submodule", "update"])
    if stdout:
        print(stdout)


def create_symlink(path):
    install_conf_path = os.path.join(path, "install.txt")
    if not os.path.isfile(install_conf_path):
        logging.debug("No install.txt for " + path)
        return
    with open(install_conf_path, "r") as install_conf:
        read_data = install_conf.read()
    move_map = eval(read_data)
    for src, dest in move_map:
        src_path = os.path.abspath(os.path.join(path, src))
        logging.debug("src: " + src_path)
        logging.debug("dest: " + dest)
        dest = os.path.expanduser(os.path.expandvars(dest))
        if os.path.lexists(dest):
            logging.debug("File already exists, renaming as .old")
            dest_old = dest + ".old"
            if os.path.isdir(dest_old) and not os.path.islink(dest_old):
                shutil.rmtree(dest_old)
            elif os.path.islink(dest_old):
                os.remove(dest_old)
            shutil.move(dest, dest + ".old")
        if not os.path.isdir(os.path.dirname(dest)):
            os.mkdir(os.path.dirname(dest))
        os.symlink(src_path, dest)


# Enable the debug mode
# logging.basicConfig(level=logging.DEBUG)
update_git_submodule()
dirs = [child for child in os.listdir() if os.path.isdir(child)]
for path in dirs:
    try:
        create_symlink(path)
    except Exception as e:
        print("Error during the dotfiles copy in the directory: " + path)
        print(e)
