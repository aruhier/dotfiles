#!/bin/sh

waybar&
nm-applet --indicator&
sleep 1
lxqt-policykit-agent&
gammastep-indicator&
nextcloud --background&
