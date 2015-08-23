from libqtile import hook
import os
import subprocess


@hook.subscribe.startup_once
def startup_once():
    home = os.path.expanduser('~')
    subprocess.call(["bash", os.path.join(home, ".screenlayout/default.sh")])
    subprocess.Popen(
        ["bash", os.path.join(home, ".config/qtile/autostart.sh")]
    )
