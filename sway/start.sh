#!/bin/sh

swaync&
lxqt-policykit-agent&
waybar&
nm-applet --indicator&
gammastep-indicator&
kdeconnect-indicator&
nextcloud --background&

sleep 3;
copyq&
