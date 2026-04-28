# User instructions

## Source Control

- Use `jj` commands instead of `git`
- `git` commands will work in colocated jj/git repos

## `gh`

`gh` CLI should work in most repos

If `gh` fails because it can't find a `.git`, run `jj git remote list` to get the Github URL and re-run the `gh` command

## Workflow rules

- Do not push changes (`git push`, `jj git push`, `jj gp`, or otherwise) unless explicitly asked to.
