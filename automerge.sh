#!/bin/bash

# Merge master and desktop in desktop
git checkout desktop
git merge --no-edit master

# Merge tour-anthony and desktop in tour-anthony
git checkout tour-anthony
git merge --no-edit desktop
