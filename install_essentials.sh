#!/bin/bash

# This script is used to install a series of packages that
# I consider essential for me to have on a Linux computer.

apt-get install -y \
  vim \
  git \
  htop \
  openssh-server \
  fail2ban \
  tmux \
  gawk \
  zsh \
  autossh \
  curl \
  cifs-utils \
  xsel \
  pass \
  silversearcher-ag \
  stow \
  unzip
