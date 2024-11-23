#!/usr/bin/env bash

if command -v brew > /dev/null ; then
  export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl@3)"
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"

  # Needed to work around "too many open files" issue
  ulimit -n 65536
else
  export KERL_CONFIGURE_OPTIONS="--without-javac"
fi
