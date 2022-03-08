#!/bin/sh

waybar&
GTK_THEME=Adwaita:dark /usr/lib/xfce4/notifyd/xfce4-notifyd&
nm-applet --indicator&
sleep 1
lxqt-policykit-agent&
gammastep-indicator&
kdeconnect-indicator&
nextcloud --background&
