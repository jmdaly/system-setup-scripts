#!/bin/bash

# This script downloads, configures, and builds the suckless
# terminal

# First, install the build dependencies
apt-get install -y libxft-dev curl make gcc libxext-dev

INSTALL_PREFIX=/usr/local
ST_VERSION=0.8.1

# Get the source:
if [ ! -d ${INSTALL_PREFIX}/src/st-${ST_VERSION} ]; then
  curl -fLo /tmp/st-${ST_VERSION}.tar.gz http://dl.suckless.org/st/st-${ST_VERSION}.tar.gz
  mkdir -p ${INSTALL_PREFIX}/src
  cd ${INSTALL_PREFIX}/src && tar xvzf /tmp/st-${ST_VERSION}.tar.gz
fi

# Get my custom config from github:
curl -fLo ${INSTALL_PREFIX}/src/st-${ST_VERSION}/config.h https://raw.githubusercontent.com/jmdaly/dotfiles/master/st/config.h

cd ${INSTALL_PREFIX}/src/st-${ST_VERSION}
make clean install
