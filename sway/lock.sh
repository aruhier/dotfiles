#!/bin/bash
# Times the screen off and puts it to background
swayidle \
    timeout 5 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' \
    after-resume 'swaymsg "output * dpms on"'&
# Locks the screen immediately
swaylock -c 000000
# Kills last background task so idle timer doesn't keep running
kill %%
