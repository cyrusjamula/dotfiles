#!/bin/bash

# Git dotfiles installation script

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_DIR="$DOTFILES_DIR"

echo "Installing Git dotfiles..."

# Backup existing .gitconfig if it exists
if [ -f "$HOME/.gitconfig" ]; then
    echo "Backing up existing .gitconfig to .gitconfig.backup"
    cp "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
fi

# Create symlink to our dotfiles .gitconfig
echo "Creating symlink for .gitconfig"
ln -sf "$GIT_DIR/.gitconfig" "$HOME/.gitconfig"

echo "Git dotfiles installation complete!"
echo "Your git configuration has been linked to: $GIT_DIR/.gitconfig"
