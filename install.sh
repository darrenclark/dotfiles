#!/usr/bin/env bash

set -euo pipefail

git submodule update --init --recursive

# Copy configs
mkdir -v -p "$HOME/.config"

for dir in .config/*; do
  ln -h -v -s "$PWD/$dir" "$HOME/$dir" || true
done

for file in .zshenv .iterm2_shell_integration.zsh .asdf .elixir-ls; do
  ln -h -v -s "$PWD/$file" "$HOME/$file" || true
done

# Copy shell scripts
mkdir -v -p "$HOME/bin"

for file in bin/*; do
  ln -h -v -s "$PWD/$file" "$HOME/$file" || true
done

if [[ ! -z "${REMOTE_CONTAINERS:-}" ]] || [[ ! -z "${CODESPACES:-}" ]]; then
  echo "Running in devcontainer, removing default ZSH config..."
  rm -v ~/.zshrc ~/.zcompdump
fi
