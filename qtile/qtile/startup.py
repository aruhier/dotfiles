from libqtile import hook
from threading import Thread
from time import sleep
from os.path import expanduser
import subprocess


def is_running(process):
    return subprocess.call(["pgrep", "-f", " ".join(process)]) == 0


def execute_once(process):
    if not is_running(process):
        Thread(target=lambda: subprocess.check_call(process)).start()


@hook.subscribe.startup
def startup():
    def blocking():
        sleep(1)
        execute_once(["bash", expanduser("~/.screenlayout/default.sh")])
        subprocess.call(["pkill", "-f", "ibus"])
        execute_once(["nm-applet"])
        execute_once(["pa-applet"])
        execute_once(["owncloud"])
        execute_once(["redshift-gtk"])
        execute_once(["xset", "-dpms"])
        execute_once(["xset", "s", "off"])
        execute_once(["xcalib", "-d", ":0",
                      expanduser("~/.icc/n55sf.icc")])

    Thread(target=blocking).start()

    def wallpaper():
        execute_once(["compton", "-cG", "--backend", "glx"])
        subprocess.call(
            ["feh", "--bg-fill", expanduser('~/.config/qtile/wallpaper.jpg')]
        )

    Thread(target=wallpaper).start()
