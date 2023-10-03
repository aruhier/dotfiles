#!/bin/bash

prog=$1
shift

while [ $# -gt 0 ]
do
  case $1 in
    -h | --help )
      show_help
      exit 0
    ;;
    --name=* )
      name=${1#*=}
    ;;
    -n | --name )
      name=$2
      shift
    ;;
  esac
  shift
done

hyprctl workspaces | grep special:$name > /dev/null
if [[ $? > 0 ]]
    then hyprctl dispatch exec "[workspace special:${name};noanim]" $prog > /dev/null
else
    hyprctl dispatch togglespecialworkspace $name > /dev/null
fi
