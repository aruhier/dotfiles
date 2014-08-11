#!/bin/bash
# Auto-merge branch between each other
#

# checkout_and_rebase branch_to_checkout branch_to_merge_in
# Cancel if any error
function checkout_and_rebase()
{
    git checkout "$1" || exit 1
    git rebase -m "$2" || exit 1
}

# Merge master and desktop in desktop
checkout_and_rebase "desktop" "master"

# Merge tour-anthony and desktop in tour-anthony
checkout_and_rebase "tour-anthony" "desktop"

if [ -f favorite ]
    then git checkout $(cat favorite) || exit 1
fi
