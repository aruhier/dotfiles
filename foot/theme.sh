#!/bin/bash

THEME=$1
if [[ -z "$THEME" ]]; then
    THEME=everforest-dark
fi

if [ ! -e ~/.config/foot/"$THEME.ini" ]; then
    echo "Theme is set to $THEME but ~/.config/foot/$THEME.ini does not exist." >&2
    exit 1
fi

if [ -e ~/.config/foot/theme.ini ]; then
    rm ~/.config/foot/theme.ini
fi
ln -s ~/.config/foot/$THEME.ini ~/.config/foot/theme.ini
