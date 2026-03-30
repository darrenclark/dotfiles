#!/usr/bin/env bash

if [ -z "$TMUX" ]; then
  exit 0
fi

pane_tty=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}')

if [[ "$pane_tty" != /dev/tty* ]]; then
  exit 0
fi

# send directly to tty to avoid Claude Code not "printing" it out
printf '\a' > "$pane_tty"
