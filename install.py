#!/usr/bin/python3
#
# "Install" all the dotfiles, by making loading the install.conf file in each
# folder and by creating simbolic link at the destination path, targetting the
# source file in the repo
#

import logging
import os
import shutil
import subprocess
from pathlib import Path

EXCLUDED_DIRS = {".git"}


def run(*cmd):
    stdout = subprocess.run(cmd, check=True, capture_output=True, text=True).stdout
    if stdout:
        print(stdout)


def update_git_submodule():
    for opt in ("init", "sync", "update"):
        run("git", "submodule", opt)


def clean_conf_line(line):
    """
    Clean install.conf entries

    :param line: line to clean
    :returns (src, dest): src is the source file path to target, dest is the
                          new symlink path
    :rtype: tuple
    """
    src, dest = line.split(":", 1)
    return src.strip(" \t\"'"), dest.strip(" \t\n\"'")


def move_existing_dest(dest: Path):
    """
    If file already exists, move it as dest.old
    """
    logging.debug("File already exists, renaming as .old")
    dest_old = dest.with_name(dest.name + ".old")
    if dest_old.is_symlink():
        dest_old.unlink()
    elif dest_old.is_dir():
        shutil.rmtree(dest_old)
    dest.rename(dest_old)


def create_symlink(path: Path):
    install_conf_path = path / "install.conf"
    if not install_conf_path.is_file():
        logging.debug("No install.conf for %s", path)
        return
    for line in install_conf_path.read_text().splitlines():
        if not line.strip():
            continue
        src, dest = clean_conf_line(line)
        src_path = (path / src).absolute()
        logging.debug("src: %s", src_path)
        logging.debug("dest: %s", dest)

        dest = Path(os.path.expandvars(dest)).expanduser().absolute()
        if dest == src_path or (dest.is_symlink() and dest.readlink() == src_path):
            continue
        if dest.is_symlink() or dest.exists():
            move_existing_dest(dest)

        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.symlink_to(src_path)

    # launch post_install.sh if any
    post_install = path / "post_install.sh"
    if post_install.exists():
        run("bash", post_install)


def main():
    # Enable the debug mode
    logging.basicConfig(level=logging.DEBUG)
    os.chdir(Path(__file__).resolve().parent)
    update_git_submodule()
    for path in Path().iterdir():
        if not path.is_dir():
            continue
        if path.name in EXCLUDED_DIRS:
            logging.debug("%s is in excluded_dirs. Ignoring it...", path)
            continue
        try:
            create_symlink(path)
        except Exception:
            logging.exception(
                "Error during the dotfiles copy in the directory: %s", path
            )


if __name__ == "__main__":
    main()
