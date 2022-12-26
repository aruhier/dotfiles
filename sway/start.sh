#!/bin/sh

swaync&
lxqt-policykit-agent&
waybar&
GTK_THEME=Adwaita:dark /usr/lib/xfce4/notifyd/xfce4-notifyd&
nm-applet --indicator&
gammastep-indicator&
kdeconnect-indicator&
nextcloud --background&
