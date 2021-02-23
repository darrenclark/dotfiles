#!/usr/bin/env bash

mkdir -v -p "$HOME/.config"

for dir in .config/*; do
  ln -v -s "$PWD/$dir" "$HOME/$dir"
done

for file in .zshenv .iterm2_shell_integration.zsh; do
  ln -v -s "$PWD/$file" "$HOME/$file"
done
