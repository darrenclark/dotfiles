#!/usr/bin/env bash

if [ -z "$TMUX" ]; then
  exit 0
fi

focused=$(tmux show-options -gvq @client_focused)
if [[ "$focused" == "1" ]]; then
  exit 0
fi

~/.claude/hooks/notification-say.sh
