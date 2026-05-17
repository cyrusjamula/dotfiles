#!/bin/bash
set -euo pipefail

# Copilot CLI statusline installation script

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPILOT_DIR="$HOME/.copilot"

echo "Installing Copilot CLI statusline..."

# Ensure .copilot directory exists
mkdir -p "$COPILOT_DIR"

# Copy statusline script and theme
echo "Installing statusline.sh"
cp "$DOTFILES_DIR/statusline.sh" "$COPILOT_DIR/statusline.sh"
chmod +x "$COPILOT_DIR/statusline.sh"

echo "Installing statusline.omp.json"
cp "$DOTFILES_DIR/statusline.omp.json" "$COPILOT_DIR/statusline.omp.json"

# Update settings.json to enable the statusline
SETTINGS_FILE="$COPILOT_DIR/settings.json"

if [[ -f "$SETTINGS_FILE" ]]; then
    # Backup existing settings
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backed up existing settings.json"

    # Merge statusline config using jq if available
    if command -v jq >/dev/null 2>&1; then
        STATUSLINE_CMD="$COPILOT_DIR/statusline.sh"
        jq --arg cmd "$STATUSLINE_CMD" '
            .statusLine = { "type": "command", "command": $cmd, "padding": 1 } |
            .experimental = true |
            .feature_flags.enabled = ((.feature_flags.enabled // []) | if any(. == "STATUS_LINE") then . else . + ["STATUS_LINE"] end)
        ' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
        echo "Updated settings.json with statusline configuration"
    else
        echo "WARNING: jq not found. Please manually add statusline config to $SETTINGS_FILE"
        echo "See the README for the required settings."
    fi
else
    # Create new settings file
    cat > "$SETTINGS_FILE" << EOF
{
  "statusLine": {
    "type": "command",
    "command": "$COPILOT_DIR/statusline.sh",
    "padding": 1
  },
  "feature_flags": {
    "enabled": [
      "STATUS_LINE"
    ]
  },
  "experimental": true
}
EOF
    echo "Created settings.json with statusline configuration"
fi

echo ""
echo "Copilot CLI statusline installation complete!"
echo "Run /restart in Copilot CLI to activate the statusline."
