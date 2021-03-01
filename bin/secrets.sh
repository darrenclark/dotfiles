#!/usr/bin/env bash

# Usage:  eval $(./secrets.sh)

set -euo pipefail

eval $(op signin)

# Lookup 'Shell Secrets' 1Password item -> "env" section -> use key/values as env vars
op get item 'Shell Secrets' | jq -r '.details.sections[] | select(.title == "env") | .fields[] | "export \(.t)=\"\(.v)\""'
