#!/usr/bin/env bash

defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock autohide -bool true
killall Dock
