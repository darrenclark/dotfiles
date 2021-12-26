#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

git submodule update --init --recursive

# Copy configs
mkdir -v -p "$HOME/.config"

for dir in .config/*; do
  ln -n -v -s "$PWD/$dir" "$HOME/$dir" || true
done

for file in .zshenv .iterm2_shell_integration.zsh .asdf .elixir-ls; do
  ln -n -v -s "$PWD/$file" "$HOME/$file" || true
done

# Copy shell scripts
mkdir -v -p "$HOME/bin"

for file in bin/*; do
  ln -n -v -s "$PWD/$file" "$HOME/$file" || true
done

if [[ ! -z $GITHUB_CODESPACE_TOKEN ]]; then
  ./apt.sh
fi
