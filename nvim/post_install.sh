#!/bin/bash

if [ -f ~/.config/nvim/init.vim -a -f ~/.config/nvim/init.lua ]
  then rm ~/.config/nvim/init.vim
fi

nvim --headless "+PlugUpdate" "+qall" 2> /dev/null
nvim --headless "+PlugClean!" "+qall" 2> /dev/null
# Force to remove all lsp clients to update them.
nvim --headless "+LspUninstallAll --no-confirm" "+qall" 2> /dev/null
