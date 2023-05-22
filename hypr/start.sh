#!/bin/sh

swaync&
lxqt-policykit-agent&
waybar --config ~/.config/waybar/config_hyprland&
nm-applet --indicator&
gammastep-indicator&
nextcloud --background&
kdeconnectd&

sleep 3;
copyq&
kdeconnect-indicator&
