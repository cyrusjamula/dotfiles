# Oh My Posh

Installs [Oh My Posh](https://ohmyposh.dev/) and configures a custom prompt theme for Bash, Zsh, and PowerShell.

## Installation

```bash
./install.sh      # Linux/macOS/WSL
.\install.ps1     # Windows PowerShell
```

## What it does

1. Installs Oh My Posh if not already present (downloads to temp file for verification, or via `winget` on Windows)
2. Adds prompt initialization to shell config files (`.bashrc`, `.bash_profile`, `.zshrc`, or PowerShell `$PROFILE`)
3. Uses the custom theme defined in `theme.omp.json`

## Theme

The included theme (`theme.omp.json`) displays:

**Left prompt (powerline style):**
- Username (with SSH indicator)
- Current directory path
- Git branch with working/staging change indicators and upstream status
- Root indicator
- Exit code (✓/✗)

**Right prompt:**
- Node.js, Go, Python runtime indicators (shown when relevant files detected)
- Shell name
- Current time

**Tooltips:**
- AWS profile/region (triggered by `aws` command)
- Azure subscription (triggered by `az` command)

**Other features:**
- Transient prompt (shows only folder + `>` for previous commands)
- Secondary prompt styling
- Custom color palette matching the Copilot statusline theme
- SSH session awareness

## Customization

Edit `theme.omp.json` directly, or replace it with a [built-in theme](https://ohmyposh.dev/docs/themes):

```bash
oh-my-posh init bash --config ~/.poshthemes/jandedobbeleer.omp.json
```

## Prerequisites

- A [Nerd Font](https://www.nerdfonts.com/) is required for powerline glyphs and icons
- Recommended: [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases) or [CascadiaCode Nerd Font](https://github.com/microsoft/cascadia-code)
