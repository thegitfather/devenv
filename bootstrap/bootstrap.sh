#!/bin/zsh

set -e

echo "==> Bootstrapping devenv..."

echo "==> Creating symlinks..."
if [ -d "$HOME/dotfiles" ]; then
    ln -sf "$HOME/dotfiles/zshrc" "$HOME/.zshrc"
    ln -sf "$HOME/dotfiles/gitconfig" "$HOME/.gitconfig"
    ln -sf "$HOME/dotfiles/gitignore_global" "$HOME/.gitignore_global"
    

    if [ -f "$HOME/dotfiles/opencode.json" ]; then
        mkdir -p "$HOME/.opencode"
        cp "$HOME/dotfiles/opencode.json" "$HOME/.opencode/opencode.json"
    fi

    if [ -f "$HOME/dotfiles/sgptrc" ]; then
        mkdir -p "$HOME/.config/shell_gpt"
        cp "$HOME/dotfiles/sgptrc" "$HOME/.config/shell_gpt/.sgptrc"
    fi
fi

echo "==> Bootstrap complete!"