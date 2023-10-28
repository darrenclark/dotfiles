#!/usr/bin/env zsh

set -euo pipefail

function print_step() {
  echo ""
  echo "$(tput bold)$1$(tput sgr0)"
  echo ""
}

function detect_os() {
  print_step "Detecting OS and package manager..."

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
function is_github_codespaces { [[ ! -z "${GITHUB_CODESPACE_TOKEN-}" ]] }

function is_arm64() { [[ $(uname -m) = arm64 ]] || [[ $(uname -m) = aarch64 ]] }

function is_brew() { [[ $PACKAGE_MANAGER = brew ]] }
function is_apt() { [[ $PACKAGE_MANAGER = apt ]] }

function init_submodules() {
  print_step "Initializing submodules..."

  git submodule update --init --recursive
}

function copy_configs() {
  print_step "Linking configuration files..."

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
  print_step "Linking bin/ scripts..."

  # Copy shell scripts
  mkdir -v -p "$HOME/bin"

  for file in bin/*; do
    ln -n -v -s "$PWD/$file" "$HOME/$file" || true
  done
}

function install_brew_if_needed() {
  print_step "Installing brew..."

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
  print_step "Installing packages from brew..."

  # This command fails when Google Chrome updates itself (I think), and brew can't upgrade it
  brew bundle install || true
}

function install_apt_packages() {
  print_step "Installing packages from apt..."

  sudo apt update -y
  grep -vE '^#' apt-packages.txt | xargs sudo apt install -y
}

function macos_defaults() {
  print_step "Setting macOS defaults..."

  ./defaults.sh
}

function install_asdf_plugins() {
  print_step "Installing asdf plugins..."

  set +u
  source ~/.asdf/asdf.sh
  set -u
  source .config/zsh/build_options.sh

  asdf plugin add elixir || asdf plugin update elixir
  asdf plugin add erlang || asdf plugin update erlang
  asdf plugin add nodejs || asdf plugin update nodejs
  asdf plugin add python || asdf plugin update python

  # uses .tool-versions in dotfiles repo
  asdf install
}

function set_asdf_global_versions() {
  print_step "Setting global asdf tool versions..."

  # Don't overwrite any global versions set on this computer
  if [[ ! -f ~/.tool-versions ]]; then
    echo "cp ./.tool-versions ~/.tool-versions"
    cp ./.tool-versions ~/.tool-versions
  else
    echo "Skipping, already set"
  fi
}

function install_go() {
  print_step "Installing go..."

  local go_version=go1.21.3
  local download_path=/tmp/go.tar.gz

  if [[ -f /usr/local/go/VERSION ]] && [[ $(head -n1 /usr/local/go/VERSION) = $go_version ]]; then
    echo "Skipping, already installed."
    return 0
  fi

  if is_mac && is_arm64 ; then
    curl -L -o $download_path "https://go.dev/dl/${go_version}.darwin-arm64.tar.gz"
  elif is_mac && ! is_arm64 ; then
    curl -L -o $download_path "https://go.dev/dl/${go_version}.darwin-amd64.tar.gz"
  elif is_linux && is_arm64 ; then
    curl -L -o $download_path "https://go.dev/dl/${go_version}.linux-arm64.tar.gz"
  elif is_linux && ! is_arm64 ; then
    curl -L -o $download_path "https://go.dev/dl/${go_version}.linux-amd64.tar.gz"
  else
    echo "Skipping, I don't know how to install go on $OS / $DISTRO"
    return 0
  fi

  sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $download_path

  rm $download_path
}

function install_rust() {
  print_step "Installing Rust..."

  export PATH=$HOME/.cargo/bin:$PATH

  if ! command -v rustup ; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  fi

  rehash

  rustup self update
  rustup update
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
! is_github_codespaces && install_asdf_plugins
! is_github_codespaces && set_asdf_global_versions
! is_github_codespaces && install_go
! is_github_codespaces && install_rust


print_step "Done!"
