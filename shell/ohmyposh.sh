#!/bin/bash

# Oh My Posh prompt initialization
# Auto-loaded by shell/init.sh

if command -v oh-my-posh >/dev/null 2>&1; then
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    eval "$(oh-my-posh init bash --config "$DOTFILES_DIR/ohmyposh/theme.omp.json")"
fi
