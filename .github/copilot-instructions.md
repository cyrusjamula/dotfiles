# Copilot Instructions

## Project Overview

This is a personal dotfiles repository that manages configuration files (git, shell) across Linux, macOS, WSL, and Windows. It uses symbolic links on Unix-like systems and supports a copy fallback on Windows.

## Repository Structure

Each configuration type lives in its own directory with:
- An `install.sh` for Bash (Linux/macOS/WSL)
- An `install.ps1` for PowerShell (Windows)
- A `README.md` describing that module
- The actual dotfiles/config files

The root `install.sh` and `install.ps1` orchestrate installation by calling each module's installer.

## Conventions

- **Shell scripts**: Use `#!/bin/bash` shebang. Use `DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"` to resolve the script's directory.
- **PowerShell scripts**: Use `$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path` to resolve the script's directory.
- **Installation pattern**: Each module's `install.sh` backs up existing configs, then creates symlinks via `ln -sf`. The corresponding `install.ps1` tries `New-Item -ItemType SymbolicLink` first, falling back to `Copy-Item` if symlinks fail.
- **Shell functions**: Defined in individual `.sh` files under `shell/` and auto-loaded by `shell/init.sh`, which sources every `.sh` file in its directory (except itself).
- **Cross-platform**: Always provide both Bash and PowerShell variants for install scripts. Keep platform-specific logic separate.

## Adding a New Dotfile Module

When adding a new configuration module (e.g., `vim/`, `tmux/`):
1. Create a new directory at the repo root with the module name.
2. Add `install.sh` and `install.ps1` following the existing pattern (backup → symlink/copy).
3. Add a `README.md` describing the module.
4. Register the new module in the root `install.sh` and `install.ps1` by adding a conditional block that calls the module's installer.

## Code Style

- Quote all Bash variables: `"$var"` not `$var`.
- Use `[[ ]]` for conditionals in Bash.
- Add descriptive `echo`/`Write-Host` output so users can follow what each script does.
- Use color output in PowerShell (`-ForegroundColor`) for status messages.
