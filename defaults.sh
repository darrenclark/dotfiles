#!/usr/bin/env bash

# Dock
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock autohide -bool true
killall Dock

# Screenshots
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location -string "~/Screenshots"
