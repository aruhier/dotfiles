#!/bin/bash

light-locker --no-lock-on-suspend &
xset -dpms &
xset s off &

nvidia-settings --load-config-only &
compton -cG --backend glx --unredir-if-possible &
feh --bg-fill ~/.config/qtile/wallpaper.jpg &
sleep 1
nm-applet &
pa-applet &
redshift-gtk &
clipit &
owncloud &
rofi -key-run mod4+r &
