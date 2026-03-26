#!/usr/bin/env bash

if [ -z "$TMUX" ]; then
  exit 0
fi

# show bell indicator in tmux status bar
printf '\a'
