#!/bin/bash

# Main shell configuration loader for dotfiles

# Get the directory of this script
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load all shell configuration files
# Skip init.sh itself and install.sh (installer, not runtime config)
for config_file in "$DOTFILES_DIR"/*.sh; do
    if [ -f "$config_file" ] \
        && [ "$config_file" != "${BASH_SOURCE[0]}" ] \
        && [ "$(basename "$config_file")" != "install.sh" ]; then
        echo "Loading: $(basename "$config_file")"
        # shellcheck source=/dev/null
        source "$config_file"
    fi
done

echo "Dotfiles shell configuration loaded!"
