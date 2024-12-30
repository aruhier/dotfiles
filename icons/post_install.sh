#!/bin/bash

for i in ~/.local/share/icons/*; do
  if [ -f "$i/index.theme" ]; then
    gtk-update-icon-cache -q $i/
  fi
done
