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

### Elixir Language Server

Setup NodeJS:

```
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf global nodejs <version>
```

Build Elixir LS:

```
cd ~/.elixir-ls
# set global erlang and elixir versions to earliest release I'll be using
asdf global erlang ...
asdf global elixir ...

mix deps.get
mix compile
mix elixir_ls.release
```

## TODO

- Default git hooks to:
  - [ ] prefill commit message based on branch's JIRA ticket
  - [ ] configure email address based on github organization

- [ ] Update `install.sh` to do everything automatically

### Vim Refactor

- [ ] Indent settings
- [ ] Ctrl P / N - run tests
- [ ] shift-K for documentation
- [ ] Ctrl A - projectionist
- [ ] `:Format` (or format on save maybe?)
- [x] autoreload externally modified files
- [x] Language server setup
  - [ ] Setup more languages
  - [ ] DAP
  - [ ] Code actions (?) - organize imports, etc.
  - [ ] super tab?
- [x] Ctrl Space to open files
- [x] `:Rg`
- [ ] GitCoAuthoredBy

New:

- [x] treesitter
  - [ ] more languages

- [ ] mini libs (mini.ai, mini.comment, mini surround, etc,)
