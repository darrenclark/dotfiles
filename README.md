# dotfiles

## Manual steps

- Install latest git
- Clone this to `~/Projects/dotfiles`
- Symlinks
  ```
  ln -s $HOME/Projects/dotfiles/.config/git $HOME/.config/git
  ```

## TODO

- Default git hooks to:
  - prefill commit message based on branch's JIRA ticket
  - configure email address based on github organization
