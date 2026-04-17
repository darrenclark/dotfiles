#!/usr/bin/env bash

# Bail silently if any dependency is missing
command -v say >/dev/null 2>&1 || exit 0
command -v swift >/dev/null 2>&1 || exit 0
[[ -x "$HOME/bin/say-if-mic-muted.swift" ]] || exit 0

project="${PWD##*/}"
if [ ! -z "$TMUX" ]; then
  window_name=$(tmux display-message -p -t "$TMUX_PANE" '#{window_name}')
  if [ ! -z "$window_name" ]; then
    project="$window_name"
  fi
fi

# kiid -> kid for better pronunciation
project=${project//kiid/kid}

exec "$HOME/bin/say-if-mic-muted.swift" "$project awaiting input"
