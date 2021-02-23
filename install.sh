#!/usr/bin/env bash

set -euo pipefail

git submodule update --init --recursive

mkdir -v -p "$HOME/.config"

for dir in .config/*; do
  ln -h -v -s "$PWD/$dir" "$HOME/$dir" || true
done

for file in .zshenv .iterm2_shell_integration.zsh .asdf; do
  ln -h -v -s "$PWD/$file" "$HOME/$file" || true
done
