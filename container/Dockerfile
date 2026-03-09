FROM archlinux:base-devel

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=devenv

ENV GIT_TERMINAL_PROMPT=0

COPY bootstrap/packages-arch.txt /tmp/packages-arch.txt

RUN pacman -Sy --noconfirm $(grep -v '^#' /tmp/packages-arch.txt | grep -v '^$' | tr '\n' ' ') && rm /tmp/packages-arch.txt

RUN groupadd -g ${GROUP_ID} ${USERNAME} && \
    useradd -u ${USER_ID} -g ${USERNAME} -m -s /bin/zsh ${USERNAME}

ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

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