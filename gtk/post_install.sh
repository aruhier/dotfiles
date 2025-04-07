#!/bin/bash

if command -v gsettings > /dev/null; then
    if gsettings list-schemas > /dev/null; then
        gsettings set org.gnome.desktop.interface font-name 'Inter Variable 11'
        gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
    else
        echo "gtk: gsettings has no schemas installed. Run any gnome software."
    fi
else
    echo "gtk: gsettings not installed, passing."
fi
