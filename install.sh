#!/bin/bash
set -euo pipefail

# Main dotfiles installation script

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles from: $DOTFILES_DIR"
echo "========================================"

# Install git dotfiles
if [[ -d "$DOTFILES_DIR/git" ]] && [[ -f "$DOTFILES_DIR/git/install.sh" ]]; then
    echo "Installing Git configuration..."
    (cd "$DOTFILES_DIR/git" && ./install.sh)
    echo ""
fi

# Install shell dotfiles (when they exist)
if [[ -d "$DOTFILES_DIR/shell" ]] && [[ -f "$DOTFILES_DIR/shell/install.sh" ]]; then
    echo "Installing Shell configuration..."
    (cd "$DOTFILES_DIR/shell" && ./install.sh)
    echo ""
fi

# Install Oh My Posh
if [[ -d "$DOTFILES_DIR/ohmyposh" ]] && [[ -f "$DOTFILES_DIR/ohmyposh/install.sh" ]]; then
    echo "Installing Oh My Posh configuration..."
    (cd "$DOTFILES_DIR/ohmyposh" && ./install.sh)
    echo ""
fi

# Install Copilot CLI statusline
if [[ -d "$DOTFILES_DIR/copilot-statusline" ]] && [[ -f "$DOTFILES_DIR/copilot-statusline/install.sh" ]]; then
    echo "Installing Copilot CLI statusline..."
    (cd "$DOTFILES_DIR/copilot-statusline" && ./install.sh)
    echo ""
fi

# Install WinGet (Windows only)
if [[ -d "$DOTFILES_DIR/winget" ]] && [[ -f "$DOTFILES_DIR/winget/install.sh" ]]; then
    echo "Installing WinGet..."
    (cd "$DOTFILES_DIR/winget" && ./install.sh)
    echo ""
fi

echo "Dotfiles installation complete!"
echo "==============================="
