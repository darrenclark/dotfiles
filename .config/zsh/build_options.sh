#!/usr/bin/env bash

if command -v brew > /dev/null ; then
  export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl@1.1)"
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"
else
  export KERL_CONFIGURE_OPTIONS="--without-javac"
fi
