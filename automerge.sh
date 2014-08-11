#!/bin/bash

# Merge master and desktop in desktop
git checkout desktop
git rebase -m master

# Merge tour-anthony and desktop in tour-anthony
git checkout tour-anthony
git rebase -m desktop

if [ -f favorite ]
    then git checkout $(cat favorite)
fi
