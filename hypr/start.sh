#!/bin/sh

swaync&
lxqt-policykit-agent&
# Enable font "boldering" to increase visibility.
FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0" waybar --config ~/.config/waybar/config_hyprland&
nm-applet --indicator&
gammastep-indicator&
flatpak run com.nextcloud.desktopclient.nextcloud --background&
kdeconnectd&

sleep 3;
copyq&
kdeconnect-indicator&
