#!/bin/bash

# Oh My Posh installation script

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_FILE="$DOTFILES_DIR/theme.omp.json"

echo "Installing Oh My Posh..."

# Install oh-my-posh if not already installed
if ! command -v oh-my-posh >/dev/null 2>&1; then
    echo "Oh My Posh not found, installing..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
else
    echo "Oh My Posh is already installed"
fi

# Function to add oh-my-posh init line to a shell config file
add_omp_init() {
    local file="$1"
    local shell_name="$2"
    local init_line="eval \"\$(oh-my-posh init $shell_name --config '$THEME_FILE')\""

    if [ -f "$file" ]; then
        if ! grep -q "oh-my-posh init" "$file"; then
            echo "Adding Oh My Posh initialization to $file"
            echo "" >> "$file"
            echo "# Oh My Posh prompt" >> "$file"
            echo "$init_line" >> "$file"
        else
            echo "Oh My Posh initialization already present in $file"
        fi
    else
        echo "Creating $file and adding Oh My Posh initialization"
        echo "# Oh My Posh prompt" > "$file"
        echo "$init_line" >> "$file"
    fi
}

# Add to bash configuration
if [ -n "$BASH_VERSION" ]; then
    add_omp_init "$HOME/.bashrc" "bash"
    add_omp_init "$HOME/.bash_profile" "bash"
fi

# Add to zsh configuration if zsh is available
if command -v zsh >/dev/null 2>&1; then
    add_omp_init "$HOME/.zshrc" "zsh"
fi

echo "Oh My Posh installation complete!"
echo "Theme: $THEME_FILE"
echo "Please restart your shell or run: source ~/.bashrc"
