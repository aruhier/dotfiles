#!/bin/bash

_GEO_CONF=~/.config/sunsetr/geo.toml

if [[ ! -f "$_GEO_CONF" ]] && command -v sunsetr >/dev/null 2>&1; then
  touch "$_GEO_CONF"
  sunsetr geo || rm "$_GEO_CONF"
fi
