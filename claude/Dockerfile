FROM ubuntu:24.04

RUN apt update && apt upgrade -y

# Fix missing tzdata
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y tzdata

# install all needed packages
RUN apt-get install -y \
    sudo    python-is-python3   zsh \
    git     python3.12-venv     wget \
    curl bat tmux \
    nano    language-pack-en \
    apt-utils   locales    build-essential \
    python3-dev     python3-pip \
    unzip

RUN install -d -m 0755 /etc/apt/keyrings
RUN curl -fsSL https://downloads.claude.ai/keys/claude-code.asc \
  -o /etc/apt/keyrings/claude-code.asc
RUN echo "deb [signed-by=/etc/apt/keyrings/claude-code.asc] https://downloads.claude.ai/claude-code/apt/stable stable main" \
  | sudo tee /etc/apt/sources.list.d/claude-code.list
RUN apt update
RUN apt install claude-code -y

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

# Configure tmux
RUN echo "set -g mouse on" > ~/.tmux.conf
RUN echo 'alias tmux="tmux -u"' >> ~/.zshrc
RUN echo 'alias claude="claude --dangerously-skip-permissions"' >> ~/.zshrc

# drop a shell
WORKDIR /home/ubuntu/app
CMD ["/bin/zsh"]