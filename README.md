# dotfiles

## Manual steps

1. Install `brew` and then
  ```sh
  brew install git openssl neovim
  ```

2. Clone this to `~/Projects/dotfiles`

3. Symlinks
  ```sh
  ln -s $HOME/Projects/dotfiles/.config/git $HOME/.config/git
  ln -s $HOME/Projects/dotfiles/.config/nvim $HOME/.config/nvim
  cp ./.zshenv ~/.zshenv
  ln -s $HOME/Projects/dotfiles/.config/zsh $HOME/.config/zsh
  ```

4. Install `asdf`
  ```sh
  # Erlang
  asdf plugin install erlang
  export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=/usr/local/opt/openssl@1.1"
  export KERL_BUILD_DOCS=yes
  asdf install erlang <version>

  # Elixir
  asdf plugin install elixir
  asdf install elixir <version>
  ```

## TODO

- Default git hooks to:
  - prefill commit message based on branch's JIRA ticket
  - configure email address based on github organization
