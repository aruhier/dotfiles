#!/bin/bash

light-locker --no-lock-on-suspend &
xset -dpms &
xset s off &

compton -cG --backend glx &
feh --bg-fill ~/.config/qtile/wallpaper.jpg &
sleep 1
nm-applet &
pa-applet &
redshift-gtk &
clipit &
owncloud &
