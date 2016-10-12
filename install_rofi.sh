#!/bin/bash

# This script downloads, configures, and builds rofi,
# a window launcher that can be used with i3 instead of
# demnu

# First, install the build dependencies
apt-get install -y git make gcc checkinstall autoconf automake pkg-config
apt-get install -y libxinerama-dev libxft-dev libpango1.0-dev libcairo2-dev libpangocairo-1.0-0 libglib2.0-dev libx11-dev libstartup-notification0-dev libxcb-ewmh-dev libxcb-ewmh2 libx11-xcb-dev

INSTALL_PREFIX=/usr/local

# Get the source:
if [ ! -d ${INSTALL_PREFIX}/src/rofi ]; then
  mkdir -p ${INSTALL_PREFIX}/src
  cd ${INSTALL_PREFIX}/src
  git clone https://github.com/DaveDavenport/rofi.git
fi

ROFI_VERSION=1.1.0
cd ${INSTALL_PREFIX}/src/rofi
git submodule update --init
git fetch --tags
git checkout ${ROFI_VERSION}
autoreconf -i
mkdir -p build && cd build
../configure
make && checkinstall -D -y --pkgname rofi --pkgversion ${ROFI_VERSION} --pkggroup x11 make install
