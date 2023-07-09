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
    counter=0
    while true
    do
        hyprctl workspaces | grep special:$name > /dev/null
        if [[ $? == 0 ]]
            then break
        fi
        if (( $counter > 50 ))
            then echo "Cannot find the scratchpad"
            exit 2
        fi
        sleep 0.2
        counter=$((counter+1))
    done
    hyprctl dispatch workspace special:$name > /dev/null
else
    hyprctl dispatch togglespecialworkspace $name > /dev/null
fi
