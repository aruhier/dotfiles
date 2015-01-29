#!/bin/bash
# Auto-merge branch between each other
#

# checkout_and_rebase branch_to_checkout branch_to_merge_in
# Cancel if any error
function checkout_and_rebase()
{
    echo "$1" > .current_merge
    git checkout "$1" || exit 1
    git pull --rebase || exit 1
    git merge --no-edit "$2" || exit 1
    rm .current_merge
}

function pre_checkout_and_rebase()
{
    if [ ! -f .current_merge ]
        then checkout_and_rebase $1 $2
        return
    fi

    stopped_merge="$(cat .current_merge)"
    if [ "$1" == "$stopped_merge" ]
        then rm .current_merge
    else
        return
    fi
}

# Merge master and desktop in desktop
pre_checkout_and_rebase "desktop" "master"

### DESKTOP CHILDS ###

    pre_checkout_and_rebase "pc-trinaps" "desktop"
    pre_checkout_and_rebase "tour-anthony" "desktop"

    ### TOUR-ANTHONY CHILDS ###

        pre_checkout_and_rebase "laptop-anthony" "tour-anthony"

    ### END TOUR-ANTHONY CHILDS ###

### END DESKTOP CHILDS ###

if [ -f favorite ]
    then git checkout $(cat favorite) || exit 1
fi
