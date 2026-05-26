#!/bin/bash

# Shell dotfiles installation script
# Safe to source: bail out if sourced rather than executed, so strict-mode
# shell options never leak into an interactive shell.
(return 0 2>/dev/null) && return 0

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_DIR="$DOTFILES_DIR"

echo "Installing shell dotfiles..."

# Add (or update) a dotfiles init.sh source line in a shell rc file.
# Matches any existing line that sources a dotfiles init.sh (regardless of path)
# so re-runs from a different clone (e.g. Codespaces persistedshare vs. the
# workspace mount) don't accumulate duplicate source lines.
add_source_line() {
    local file="$1"
    local source_line="$2"

    if [[ -f "$file" ]]; then
        local matches
        matches="$(grep -Ec '^[[:space:]]*(source|\.)[[:space:]]+["'\'']?.*/shell/init\.sh["'\'']?[[:space:]]*$' "$file" || true)"

        if [[ "$matches" -eq 0 ]]; then
            echo "Adding dotfiles initialization to $file"
            echo "" >> "$file"
            echo "# Load dotfiles shell configuration" >> "$file"
            echo "$source_line" >> "$file"
        elif [[ "$matches" -eq 1 ]] && grep -Fxq "$source_line" "$file"; then
            echo "Dotfiles initialization already present in $file"
        else
            echo "Consolidating dotfiles initialization in $file ($matches existing lines)"
            local tmp
            tmp="$(mktemp)"
            awk -v new="$source_line" '
                /^[[:space:]]*(source|\.)[[:space:]]+["'\'']?.*\/shell\/init\.sh["'\'']?[[:space:]]*$/ {
                    if (!seen) { print new; seen = 1 }
                    next
                }
                { print }
            ' "$file" > "$tmp" && mv "$tmp" "$file"
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
