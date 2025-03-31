function vn --description 'Vim notes'
    set -l NOTE (test -n "$argv[1]"; and echo "$argv[1]"; or echo "Notepad.md")

    set -l NOTES_DIR
    if test -d ~/Nextcloud/Notes
        set NOTES_DIR ~/Nextcloud/Notes
    else
        set NOTES_DIR ~/Notes
        mkdir -p $NOTES_DIR
    end

    vim + $NOTES_DIR/$NOTE +'silent foldopen!'
end
