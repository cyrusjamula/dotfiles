# Oh My Posh

Installs [Oh My Posh](https://ohmyposh.dev/) and configures a custom prompt theme for Bash, Zsh, and PowerShell.

## Installation

**Linux/macOS/WSL:**

```bash
cd ohmyposh
./install.sh
```

**Windows PowerShell:**

```powershell
Set-Location ohmyposh
.\install.ps1
```

## What it does

1. Installs Oh My Posh if it is not already present (using a temporary download on Linux/macOS/WSL or `winget` on Windows)
2. Adds prompt initialization to shell config files (`.bashrc`, `.bash_profile`, `.zshrc`, or PowerShell `$PROFILE`)
3. Uses the custom theme defined in `theme.omp.json`

The installer does not replace an existing line containing `oh-my-posh init`. If another theme is already configured, update that line manually to use this repository's `theme.omp.json`.

After installation, restart the shell. Bash users can instead run `source ~/.bashrc`, and PowerShell users can run `. $PROFILE`.

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

- `curl` and Bash on Linux/macOS/WSL
- WinGet on Windows
- A [Nerd Font](https://www.nerdfonts.com/) is required for powerline glyphs and icons
- Recommended: [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases) or [CascadiaCode Nerd Font](https://github.com/microsoft/cascadia-code)

Verify the installation with:

```bash
oh-my-posh version
```
