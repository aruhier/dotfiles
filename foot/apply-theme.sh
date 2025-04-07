#/bin/bash

# Taken from https://codeberg.org/dnkl/foot/issues/708#issuecomment-1635542
CONFIG_PATH=~/.config/foot/theme.ini
SHELL_NAME="fish"
pattern=""

generate_pattern() {
    # Colors: regular0-7 and bright0-7
    while read color_type idx r g b; do
        if [ "$color_type" = "bright" ]; then
            idx=$((idx + 8))
        fi
        pattern+=$'\e]4;'"$idx"$';rgb:'"$r"'/'"$g"'/'"$b"$'\e\\'
    done < <(sed -n -r 's/^\w*(regular|bright)([0-9])=([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2}).*/\1 \2 \3 \4 \5/p' "$CONFIG_PATH")

    # ex: 'foreground=ffffff'
    while read r g b; do
        pattern+=$'\e]10;rgb:'"$r"'/'"$g"'/'"$b"$'\e\\'
    done < <(sed -n -r 's/^\w*foreground=([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2}).*/\1 \2 \3/p' "$CONFIG_PATH")

    # ex: 'background=0b0b0b'
    while read r g b; do
        pattern+=$'\e]11;rgb:'"$r"'/'"$g"'/'"$b"$'\e\\'
    done < <(sed -n -r 's/^\w*background=([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2}).*/\1 \2 \3/p' "$CONFIG_PATH")
}


generate_pattern
ps -eo pid,ppid,comm -u $USER | awk '$3 == "'"$SHELL_NAME"'" { print $1, $2 }' | while read pid ppid; do
    (
        if (ps -p "$ppid" -o comm= | grep -q "^foot$"); then
            echo -ne $pattern >> /proc/$pid/fd/0 &
        fi
    )&
done
