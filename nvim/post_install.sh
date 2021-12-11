#!/bin/bash

current_dir=`dirname "$(readlink -f "$0")"`

if [ -f ~/.config/nvim/init.vim -a -f ~/.config/nvim/init.lua ]
  then rm ~/.config/nvim/init.vim
fi

if [ ! -e ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]
  then git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  echo "!!! WARNING !!! nvim moved to Packer, please remove your vim-plug plugins"
fi

nvim --headless "+PackerSync!" "+qall" 2> /dev/null
# Force to remove all lsp clients to update them.
nvim --headless "+LspUninstallAll --no-confirm" "+qall" 2> /dev/null
