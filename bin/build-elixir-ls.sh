#!/usr/bin/env bash

cd ~/.elixir-ls
mix deps.get && mix compile && mix elixir_ls.release -o release
