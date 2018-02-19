#!/bin/bash

git show master:zsh/zshrc > ~/.sshrc.d/.zshrc
git show master:tmux/tmux.conf > ~/.sshrc.d/.tmux.conf
git show master:vim/vimrc > ~/.sshrc.d/.vimrc

mkdir -p ~/.sshrc.d/plugged/
ln -sf `git rev-parse --show-toplevel`/nvim/plugged/plug.vim ~/.sshrc.d/plugged/plug.vim
