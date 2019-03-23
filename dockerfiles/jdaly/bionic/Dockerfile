FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y software-properties-common \
    locales zsh git

# Add a user to the system
RUN useradd --create-home --shell /bin/zsh jdaly
RUN echo 'jdaly:letmein' | chpasswd

# Give this user sudo access
RUN addgroup jdaly sudo

COPY .ssh/* /home/jdaly/.ssh/
RUN chown jdaly:jdaly /home/jdaly/.ssh/* && chmod 600 /home/jdaly/.ssh/*
RUN chown jdaly:jdaly /home/jdaly/.ssh

# Clone my system setup scripts
USER jdaly
RUN mkdir -p /home/jdaly/git
RUN GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone git@github.com:jmdaly/system-setup-scripts.git /home/jdaly/git/system-setup-scripts

# Run some scripts to setup the environment
USER root
RUN /home/jdaly/git/system-setup-scripts/install_essentials.sh
RUN /home/jdaly/git/system-setup-scripts/install_development.sh
RUN /home/jdaly/git/system-setup-scripts/install_neovim.sh
RUN /home/jdaly/git/system-setup-scripts/install_tmux.sh
RUN /home/jdaly/git/system-setup-scripts/install_st.sh

# We need gcc 7 in order to build ccls.
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get install -y g++-7
# The above PPA would upgrade gcc 5 on us, but we want to stick
# to the version that ships with Ubuntu 16.04, so we now remove
# the repo
RUN add-apt-repository --remove ppa:ubuntu-toolchain-r/test
RUN apt-get update

# Generate the locale
RUN locale-gen en_US.UTF-8  

RUN apt-get clean

# We need a newer version of cmake which knows about C++17,
# in order to build ccls
RUN cd /tmp && wget https://cmake.org/files/v3.12/cmake-3.12.2-Linux-x86_64.sh && chmod 755 cmake-3.12.2-Linux-x86_64.sh
USER root
RUN /tmp/cmake-3.12.2-Linux-x86_64.sh --prefix=/usr/local --skip-license

# Install clang
RUN cd /tmp && wget http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz
RUN cd /opt && tar xaf /tmp/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz
RUN ln -s /opt/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04 /opt/llvm
RUN rm -rf /tmp/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz

USER jdaly
# Set the locale
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Install zplug manually. The automatic install doesn't
# seem to work inside of a docker container. See:
# https://github.com/zplug/zplug/issues/282
RUN GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone git@github.com:zplug/zplug /home/jdaly/.zplug	

# Setup dotfiles
RUN GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone git@github.com:jmdaly/dotfiles.git /home/jdaly/dotfiles	
RUN /home/jdaly/dotfiles/setup_dotfiles.sh

# Setup secure setup
RUN GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone git@gitlab.com:jmdaly/secure-setup.git /home/jdaly/secure-setup	
RUN /home/jdaly/secure-setup/setup_secure.sh

# Install vim plugins
RUN nvim +PlugInstall +qall

# Build YouCompleteMe
RUN /home/jdaly/.vim/plugged/YouCompleteMe/install.py --clang-completer

# Install ccls
USER jdaly
RUN GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone --recursive git@github.com:MaskRay/ccls.git /home/jdaly/git/ccls
RUN mkdir -p /home/jdaly/git/ccls/build
RUN cd /home/jdaly/git/ccls/build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_CXX_COMPILER=/opt/llvm/bin/clang++ -DCMAKE_PREFIX_PATH=/opt/llvm && \
    cmake --build .

USER root
RUN cd /home/jdaly/git/ccls/build && cmake --build . --target install

USER jdaly
WORKDIR /home/jdaly
