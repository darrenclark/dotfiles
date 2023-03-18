#!/usr/bin/env zsh

mkdir -p /tmp/dotfiles-vim-refactor-share
export XDG_DATA_HOME=/tmp/dotfiles-vim-refactor-share
export XDG_CONFIG_HOME=/Users/darren/Projects/dotfiles-vim-refactor/.config
nvim "$@"
