#!/bin/bash

# Shell dotfiles installation script

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_DIR="$DOTFILES_DIR"

echo "Installing shell dotfiles..."

# Function to add source line to a file if it doesn't exist
add_source_line() {
    local file="$1"
    local source_line="$2"
    
    if [ -f "$file" ]; then
        if ! grep -Fxq "$source_line" "$file"; then
            echo "Adding dotfiles initialization to $file"
            echo "" >> "$file"
            echo "# Load dotfiles shell configuration" >> "$file"
            echo "$source_line" >> "$file"
        else
            echo "Dotfiles initialization already present in $file"
        fi
    else
        echo "Creating $file and adding dotfiles initialization"
        echo "# Load dotfiles shell configuration" > "$file"
        echo "$source_line" >> "$file"
    fi
}

# Source line to add
SOURCE_LINE="source \"$SHELL_DIR/init.sh\""

# Add to bash configuration files
if [ -n "$BASH_VERSION" ]; then
    add_source_line "$HOME/.bashrc" "$SOURCE_LINE"
    add_source_line "$HOME/.bash_profile" "$SOURCE_LINE"
fi

# Add to zsh configuration if zsh is available
if command -v zsh >/dev/null 2>&1; then
    add_source_line "$HOME/.zshrc" "$SOURCE_LINE"
fi

echo "Shell dotfiles installation complete!"
echo "Please restart your shell or run: source ~/.bashrc"
echo ""
echo "Available commands:"
echo "  clearOldBranches - Remove local branches that have been deleted from remote"
