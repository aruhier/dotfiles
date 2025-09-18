#!/bin/bash

current_dir=`dirname "$(readlink -f "$0")"`

if [ -f ~/.config/nvim/init.vim -a -f ~/.config/nvim/init.lua ]
  then rm ~/.config/nvim/init.vim
fi

if [ -e ~/.local/share/nvim/site/pack ]; then
  echo "!!! WARNING !!! nvim moved to Packer"
  rm -rf ~/.local/share/nvim/site/pack
fi

nvim --headless "+Lazy! sync" +qa 2> /dev/null
# Update the LSPs.
nvim --headless "+MasonToolsUpdate" "+qall" 2> /dev/null
