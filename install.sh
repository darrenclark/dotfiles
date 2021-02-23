#!/usr/bin/env bash

mkdir -v -p "$HOME/.config"

for dir in .config/*; do
  ln -v -s "$PWD/$dir" "$HOME/$dir"
done

for file in .zshenv; do
  ln -v -s "$PWD/$file" "$HOME/$file"
done
