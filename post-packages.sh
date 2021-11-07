#!/usr/bin/env bash

set -euo pipefail

if [ -f /opt/homebrew/opt/fzf/install ] && [ ! -f ~/.fzf.sh ]; then
  /opt/homebrew/opt/fzf/install --key-bindings --completion --no-update-rc
fi
