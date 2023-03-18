#!/usr/bin/env zsh

set -euo pipefail

function detect_os() {
  export OS=$(uname)

  if [[ $OS = Linux ]]; then
    if [[ -f /etc/os-release ]]; then
      export DISTRO=$(source /etc/os-release && echo $ID)
    else
      export DISTRO=unknown
    fi
  elif [[ $OS = Darwin ]]; then
    export DISTRO=macos
  else
    echo "Unknown OS: $OS"

    export OS=unknown
    export DISTRO=unknown
  fi

  case $DISTRO in
  macos)
    export PACKAGE_MANAGER=brew
  ;;
  ubuntu)
    export PACKAGE_MANAGER=apt
  ;;
  *)
    export PACKAGE_MANAGER=none
  ;;
  esac
}

function is_mac() { [[ $OS = Darwin ]] }
function is_linux() { [[ $OS = Linux ]] }

function is_arm64() { [[ $(uname -m) = arm64 ]] }

function is_brew() { [[ $PACKAGE_MANAGER = brew ]] }
function is_apt() { [[ $PACKAGE_MANAGER = apt ]] }

function init_submodules() {
  git submodule update --init --recursive
}

function copy_configs() {
  # Copy configs
  mkdir -v -p "$HOME/.config"

  for dir in .config/*; do
    ln -n -v -s "$PWD/$dir" "$HOME/$dir" || true
  done

  for file in .zshenv .iterm2_shell_integration.zsh .asdf .elixir-ls; do
    ln -n -v -s "$PWD/$file" "$HOME/$file" || true
  done
}

function copy_shell_scripts() {
  # Copy shell scripts
  mkdir -v -p "$HOME/bin"

  for file in bin/*; do
    ln -n -v -s "$PWD/$file" "$HOME/$file" || true
  done
}

function install_brew_if_needed() {
  local brew_prefix=""
  if is_mac && is_arm64 ; then
    brew_prefix=/opt/homebrew
  elif is_mac && ! is_arm64 ; then
    brew_prefix=/usr/local
  elif is_linux ; then
    brew_prefix=/home/linuxbrew/.linuxbrew
  fi

  if [[ ! -f "$brew_prefix/bin/brew" ]] ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval $($brew_prefix/bin/brew shellenv)
  else
    echo "Brew already installed.. skipping"
  fi
}

function brew_bundle_install() {
  # This command fails when Google Chrome updates itself (I think), and brew can't upgrade it
  brew bundle install || true
}

function install_apt_packages() {
  sudo apt update -y
  grep -vE '^#' apt-packages.txt | xargs sudo apt install -y
}

function macos_defaults() {
  ./defaults.sh
}

# ---

detect_os
init_submodules
copy_configs
copy_shell_scripts
is_mac && macos_defaults
is_brew && install_brew_if_needed
is_brew && brew_bundle_install
is_apt && install_apt_packages
