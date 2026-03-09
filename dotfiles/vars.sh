# sudoedit
export EDITOR="/usr/sbin/nano"

LC_COLLATE=C ; export LC_COLLATE

if [ -d "$HOME/dotfiles/scripts" ]; then
  PATH=$PATH:${HOME}/dotfiles/scripts
fi

if [ -d "$HOME/local/n/bin" ]; then
  PATH=$HOME/local/n/bin:$PATH
fi

export PATH