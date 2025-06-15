#!/bin/bash

# Main dotfiles installation script

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles from: $DOTFILES_DIR"
echo "========================================"

# Install git dotfiles
if [ -d "$DOTFILES_DIR/git" ] && [ -f "$DOTFILES_DIR/git/install.sh" ]; then
    echo "Installing Git configuration..."
    cd "$DOTFILES_DIR/git"
    ./install.sh
    echo ""
fi

# Install shell dotfiles (when they exist)
if [ -d "$DOTFILES_DIR/shell" ] && [ -f "$DOTFILES_DIR/shell/install.sh" ]; then
    echo "Installing Shell configuration..."
    cd "$DOTFILES_DIR/shell"
    ./install.sh
    echo ""
fi

echo "Dotfiles installation complete!"
echo "==============================="
