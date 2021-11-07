# dotfiles

## Manual steps

Mac:

```sh
./install.sh
./brew_once.sh
./brew.sh
./post-packages.sh
```

Linux:

```sh
./install.sh
./apt.sh
./post-packages.sh
```

## adsf - Erlang / Elixir

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
  - [ ] prefill commit message based on branch's JIRA ticket
  - [ ] configure email address based on github organization

- [ ] Update `install.sh` to do everything automatically
