FROM ubuntu:24.04

# Add 32 bit binaries support
RUN dpkg --add-architecture i386
RUN apt update && apt upgrade -y

# Fix missing tzdata
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y tzdata

# install all needed packages
RUN apt-get install -y \
    sudo    python-is-python3   zsh \
    git     python3.12-venv     wget \
    curl    gdb netcat-openbsd \
    strace  ltrace  bat \
    nano    language-pack-en \
    apt-utils   locales    build-essential \
    gcc-multilib    g++-multilib    gdb \
    gdb-multiarch   python3-dev     python3-pip \
    man-db  manpages-posix net-tools    cmake \
    rubygems    ruby-dev    tmux \
    binwalk     autoconf    socat \
    exiftool    squashfs-tools  unzip \
    man-db manpages-dev libtool-bin \
    libssl-dev      libffi-dev  libc6-dbg \
    libc6:i386  libc6-dbg:i386  libstdc++6:i386 \
    libc6-dev-i386 elfutils patchelf

RUN apt-get -y autoremove

# add ubuntu user to sudoers
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers



###########################################################
###                                                     ###
###                  ubuntu user setup                  ###
###                                                     ###
###########################################################
USER ubuntu
WORKDIR /home/ubuntu

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN sudo chsh --shell /bin/zsh
RUN sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc
RUN sed -i 's/^: ${AGNOSTER_DIR_BG:=blue}/: ${AGNOSTER_DIR_BG:=red}/' ~/.oh-my-zsh/themes/agnoster.zsh-theme
RUN echo 'export SHELL=/bin/zsh' >> ~/.zshrc

# make python venv with pwntools and more
RUN python -m venv ctf
RUN echo "source ~/ctf/bin/activate" >> .zshrc

RUN /bin/sh -c ". ~/ctf/bin/activate && python -m pip install --upgrade pip"
RUN /bin/sh -c ". ~/ctf/bin/activate && pip install \
    pwntools ropper ROPgadget"

# install one_gadget
RUN gem install --user-install \
    one_gadget seccomp-tools 

# install pwndbg
RUN git clone https://github.com/pwndbg/pwndbg.git pwndbg && \
    cd ~/pwndbg && \
    ./setup.sh

RUN sudo /bin/sh -c "echo 'source /home/ubuntu/pwndbg/gdbinit.py' >> /root/.gdbinit"

# Configure tmux
RUN echo "set -g mouse on" > ~/.tmux.conf
RUN echo 'alias tmux="tmux -u"' >> ~/.zshrc

# drop a shell
WORKDIR /home/ubuntu/chall
CMD ["/bin/zsh"]