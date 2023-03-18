#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

if ! command -v zsh > /dev/null ; then
  if command -v apt > /dev/null ; then
    sudo apt update -y && sudo apt install -y zsh
  else
    echo "zsh not available, aborting"
    exit 1
  fi
fi

exec zsh ./do_install.sh
