from libqtile import hook
import os
import subprocess


@hook.subscribe.startup_once
def startup_once():
    home = os.path.expanduser('~')
    subprocess.call(["bash", os.path.join(home, ".config/qtile/autostart.sh")])


@hook.subscribe.startup
def startup():
    home = os.path.expanduser('~')
    subprocess.call(["xcalib", "-d", ":0",
                     os.path.join(home, '.icc/n55sf.icc')])
