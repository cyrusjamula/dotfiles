# Oh My Posh

Installs [Oh My Posh](https://ohmyposh.dev/) and configures a custom prompt theme for Bash, Zsh, and PowerShell.

## What it does

- Installs Oh My Posh if not already present
- Adds prompt initialization to shell config files (`.bashrc`, `.bash_profile`, `.zshrc`, or PowerShell `$PROFILE`)
- Uses a custom theme defined in `theme.omp.json`

## Theme

The included theme displays:

- Username and hostname
- Current directory path
- Git branch with working/staging change indicators
- A two-line prompt with `❯` on the second line

Edit `theme.omp.json` to customize, or replace it with a [built-in theme](https://ohmyposh.dev/docs/themes).

## Prerequisites

A [Nerd Font](https://www.nerdfonts.com/) is recommended for full icon support in your terminal.
