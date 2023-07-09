#!/bin/sh

swaync&
lxqt-policykit-agent&
waybar --config ~/.config/waybar/config_hyprland&
nm-applet --indicator&
gammastep-indicator&
flatpak run com.nextcloud.desktopclient.nextcloud --background&
kdeconnectd&

sleep 3;
copyq&
kdeconnect-indicator&
