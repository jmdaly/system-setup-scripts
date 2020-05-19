#!/bin/bash

# This script is used to install a series of tools that
# I use for software development

apt-get install -y g++ \
  gdb \
  clang \
  ccache \
  distcc \
  doxygen \
  graphviz \
  cppcheck \
  cmake \
  cmake-curses-gui \
  cmake-qt-gui \
  make \
  ninja-build \
  build-essential \
  colordiff
