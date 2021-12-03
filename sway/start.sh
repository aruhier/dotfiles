#!/bin/sh

waybar&
nm-applet --indicator&
sleep 1
lxqt-policykit-agent&
gammastep-indicator&
kdeconnect-indicator&
nextcloud --background&
