# dotfiles

## Manual steps

### Mac

#### 1. Run the shell commands:

```sh
./install.sh
./brew_once.sh

# (open a new shell window)

./brew.sh
./post-packages.sh

./defaults.sh
```

#### N. Map Caps Lock to Control

System Preferences -> Keyboard -> Modifier Keys

#### N. Configure iTerm

1. iTerm -> Preferences -> General -> Preferences

2. Load from custom folder or URL: `/Users/dclark/Projects/dotfiles`

3. Restart iTerm

#### N. Configure Rectangle

Launch `Rectangle.app`, choose 'Spectacle' settings, open Preferences and import `./RectangleConfig.json`

#### N. Login to github:

```
gh auth login
```


### Linux

```sh
./install.sh
./apt.sh
./post-packages.sh
```

## adsf - Erlang / Elixir

```sh
# Erlang
asdf plugin add erlang
export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=/usr/local/opt/openssl@1.1"
export KERL_BUILD_DOCS=yes
asdf install erlang <version>

# Elixir
asdf plugin add elixir
asdf install elixir <version>
```

## TODO

- Default git hooks to:
  - [ ] prefill commit message based on branch's JIRA ticket
  - [ ] configure email address based on github organization

- [ ] Update `install.sh` to do everything automatically
