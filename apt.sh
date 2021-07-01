#!/usr/bin/env bash

sudo apt update -y
grep -vE '^#' apt-packages.txt | xargs sudo apt install -y
