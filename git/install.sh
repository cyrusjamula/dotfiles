#!/bin/bash
set -euo pipefail

# Git dotfiles installation script

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_DIR="$DOTFILES_DIR"

echo "Installing Git dotfiles..."

# Backup existing .gitconfig if it exists and is not already a symlink to ours
if [[ -f "$HOME/.gitconfig" ]] && [[ ! "$HOME/.gitconfig" -ef "$GIT_DIR/.gitconfig" ]]; then
    BACKUP="$HOME/.gitconfig.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing .gitconfig to $BACKUP"
    cp "$HOME/.gitconfig" "$BACKUP"
fi

# Create symlink to our dotfiles .gitconfig
echo "Creating symlink for .gitconfig"
ln -sf "$GIT_DIR/.gitconfig" "$HOME/.gitconfig"

echo "Git dotfiles installation complete!"
echo "Your git configuration has been linked to: $GIT_DIR/.gitconfig"
