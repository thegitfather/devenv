FROM debian:bookworm

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=devenv

ENV GIT_TERMINAL_PROMPT=0
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    procps \
    && rm -rf /var/lib/apt/lists/*

COPY bootstrap/packages-debian.txt /tmp/packages-debian.txt

RUN apt-get update && apt-get install -y $(grep -v '^#' /tmp/packages-debian.txt | grep -v '^$' | tr '\n' ' ') && rm /tmp/packages-debian.txt && rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /etc/profile

ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/${USERNAME}/.local/bin:${PATH}"

RUN brew install opencode

RUN group_name=$(getent group ${GROUP_ID} | cut -d: -f1) && \
    if [ -z "$group_name" ]; then \
      groupadd -g ${GROUP_ID} ${USERNAME} && group_name=${USERNAME}; \
    fi && \
    useradd -u ${USER_ID} -g $group_name -m -s /bin/zsh ${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN pipx install shell-gpt

RUN npm config set prefix ~/.local && npm install -g pnpm

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

RUN git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

RUN git clone --depth 1 https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

RUN git clone --depth 1 https://github.com/z-shell/F-Sy-H ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/F-Sy-H

USER root
RUN chsh -s /bin/zsh ${USERNAME}
USER ${USERNAME}

CMD ["/bin/zsh"]