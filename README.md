# dotfiles

## Manual steps

### Mac

#### 1. Run the shell commands:

```sh
./install.sh
```

#### N. Map Caps Lock to Control

System Preferences -> Keyboard -> Modifier Keys

#### N. Configure iTerm

1. iTerm -> Preferences -> General -> Preferences

2. Load from custom folder or URL: `/Users/dclark/Projects/dotfiles`

3. Restart iTerm

#### N. Configure Rectangle

Launch `Rectangle.app`, choose 'Spectacle' settings, open Preferences and import `./RectangleConfig.json`

#### N. Start Hammerspoon at launch

Launch `Hammerspoon.app`, update preferences to start at login & hide menu bar item

#### N. Login to github:

```sh
gh auth login
```

#### N. Configure work-specific Git and JJ settings - email, commit signing, etc.

Add `~/.local.gitconfig` with something like:

```
[user]
    name = Darren Clark
    email = darren.clark@example.com
    signingkey = C9D82E4CF423E7F6

[commit]
    gpgsign = true
```

Add `~/.config/jj/conf.d/work.toml` with:

```
--when.repositories = ["~/the/work/repos"]

[user]
email = "darren.clark@example.com"

[signing]
behavior = "own"
backend = "gpg"
```

#### N. Configure work-specific JIRA settings

Add `~/.local.zsh` with something like:

```sh
export JIRA_BOARD_URL='https://example.atlassian.net/jira/projects?page=1&sortKey=name&sortOrder=ASC'
export JIRA_TICKET_BASE_URL='https://example.atlassian.net/browse'
```

### Linux

```sh
./install.sh
```


## adsf - Erlang / Elixir

```sh
# Erlang
ulimit -n 65536  # work around "too many open files" issue
asdf plugin add erlang
asdf install erlang $version

# Elixir
asdf plugin add elixir
asdf install elixir $version
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

- [x] Update `install.sh` to do everything automatically

### Vim Refactor

- [ ] Indent settings
- [ ] Ctrl P / N - run tests
- [x] shift-K for documentation
- [x] Ctrl A - projectionist
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

### Bugs to address


# How To

## Add new programming language to vim config

- Configure LSP in `lsp.lua`
- Configure test adapter in `neotest.lua`
- Add language to treesitter in `treesitter.lua`
