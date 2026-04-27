# Copilot Instructions

## Project Overview

Personal dotfiles repository managing configuration files (git, shell, prompt) across Linux, macOS, WSL, and Windows. Uses symbolic links on Unix-like systems with a copy fallback on Windows.

## Installation

```bash
# Install everything (Linux/macOS/WSL)
./install.sh

# Install everything (Windows PowerShell)
.\install.ps1

# Install a single module
cd git && ./install.sh
```

No build, test, or lint tooling exists in this repository.

## Architecture

**Module system:** Each top-level directory (`git/`, `shell/`, `ohmyposh/`) is a self-contained module with its own `install.sh`, `install.ps1`, and `README.md`. The root install scripts orchestrate by conditionally calling each module's installer.

**Shell auto-loading:** `shell/init.sh` sources every `*.sh` file in the `shell/` directory (except itself). New shell functions are added by creating a new `.sh` file in `shell/` — no registration needed. Functions must be exported with `export -f` to be available in subshells.

**VS Code integration:** The `dotfiles.code-workspace` sets `BASH_ENV` to auto-load shell config in integrated terminals and provides a "Load Dotfiles" build task.

## Conventions

- **Directory resolution (Bash):** `DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"`
- **Directory resolution (PowerShell):** `$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path`
- **Install pattern — symlink (Bash):** Back up existing config → create symlink with `ln -sf` (used by `git/`, `ohmyposh/`)
- **Install pattern — source injection:** Append a `source` line to rc files (`.bashrc`, `.bash_profile`, `.zshrc`) if not already present, using `grep` to avoid duplicates (used by `shell/`)
- **Install pattern (PowerShell):** Try `New-Item -ItemType SymbolicLink` → fall back to `Copy-Item`
- **Guard external tools:** Use `command -v <tool> >/dev/null 2>&1` before invoking optional dependencies (see `shell/ohmyposh.sh`)
- **Cross-platform:** Always provide both Bash and PowerShell variants for install scripts
- **Commit messages:** Use conventional commit format (e.g., `feat: Add vim dotfiles`)

## Code Style

- Quote all Bash variables: `"$var"` not `$var`
- Use `[[ ]]` for conditionals in Bash
- Add descriptive `echo`/`Write-Host` output so users can follow what each script does
- Use color output in PowerShell (`-ForegroundColor`) for status messages
- Use `#!/bin/bash` shebang for all shell scripts

## Adding a New Module

1. Create a directory at the repo root (e.g., `vim/`)
2. Add `install.sh` and `install.ps1` following the backup → symlink/copy pattern
3. Add a `README.md` describing the module
4. Register the module in both root `install.sh` and `install.ps1` with a conditional block:
   ```bash
   if [ -d "$DOTFILES_DIR/vim" ] && [ -f "$DOTFILES_DIR/vim/install.sh" ]; then
       echo "Installing Vim configuration..."
       cd "$DOTFILES_DIR/vim"
       ./install.sh
       echo ""
   fi
   ```
5. Update root `README.md` to document the new module
