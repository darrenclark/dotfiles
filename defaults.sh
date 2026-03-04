#!/usr/bin/env bash

# Dock
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock autohide -bool true

# Restart Dock
launchctl stop com.apple.Dock.agent
sleep 0.1
launchctl start com.apple.Dock.agent

# Disable annoying predictive emoji picker (reboot required)
defaults write /Library/Preferences/FeatureFlags/Domain/UIKit.plist emoji_enhancements -dict-add Enabled -bool NO

# Screenshots
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location -string "~/Screenshots"
