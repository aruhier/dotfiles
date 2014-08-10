#!/bin/bash

# Merge master and desktop in desktop
git checkout desktop
git rebase master

# Merge tour-anthony and desktop in tour-anthony
git checkout tour-anthony
git rebase desktop

if [ -f favorite ]
    then git checkout $(cat favorite)
fi
