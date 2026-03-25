#!/usr/bin/env bash

# Bail silently if any dependency is missing
command -v say >/dev/null 2>&1 || exit 0
command -v swift >/dev/null 2>&1 || exit 0
[[ -x "$HOME/bin/say-if-mic-muted.swift" ]] || exit 0

exec "$HOME/bin/say-if-mic-muted.swift" "${PWD##*/} awaiting input"
