#!/bin/bash
# Times the screen off and puts it to background
swayidle \
    timeout 5 'hyprctl dispatcher dpms off' \
    resume 'hyprctl dispatcher dpms on' &
# Locks the screen immediately. Needs swaylock-fprintd-git
swaylock -p -c 000000
# Kills last background task so idle timer doesn't keep running
kill %%
