#!/bin/sh

swaync&
lxqt-policykit-agent&
# Enable font "boldering" to increase visibility.
FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0" waybar&
nm-applet --indicator&
gammastep-indicator&
kdeconnect-indicator&
nextcloud --background&

sleep 3;
copyq&
