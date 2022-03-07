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
    --filters=* )
        filters=${1#*=}
    ;;
    -f | --filters )
      filters=$2
      shift
    ;;
    --width=* )
      width=${1#*=}
    ;;
    -w | --width )
      width=$2
      shift
    ;;
    --height=* )
      height=${1#*=}
    ;;
    -h | --height )
      height=$2
      shift
    ;;
    -x )
      posx=$2
      shift
    ;;
    -y )
      posy=$2
      shift
    ;;
  esac
  shift
done

swaymsg $filters scratchpad show > /dev/null
if [[ $? > 0 ]]
    then exec $prog&
    counter=0
    while true
    do
        swaymsg $filters move window to scratchpad > /dev/null
        if [[ $? == 0 ]]
            then break
        fi
        if (( $counter > 50 ))
            then echo "Cannot find the window"
            exit 2
        fi
        sleep 0.2
        counter=$((counter+1))
    done

    swaymsg $filters focus > /dev/null
fi
sway $filters resize set width $width height $height > /dev/null
sway $filters move position $posx $posy > /dev/null
