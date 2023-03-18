#!/usr/bin/env bash

if command -v brew > /dev/null ; then
  export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl@1.1)"
else
  export KERL_CONFIGURE_OPTIONS="--without-javac"
fi
