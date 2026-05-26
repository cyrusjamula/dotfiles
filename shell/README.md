# Shell Configuration

Shell functions and initialization for Bash and Zsh. Auto-loads all `.sh` files in this directory on terminal startup.

## Installation

```bash
./install.sh
```

This adds a `source` line to `.bashrc`, `.bash_profile`, and `.zshrc` (if Zsh is available) pointing to `init.sh`.

## How it works

`init.sh` sources every `*.sh` file in the `shell/` directory (except itself and `install.sh`). To add a new function, create a new `.sh` file — no registration needed.

Functions are exported with `export -f` to be available in subshells.

## Available Functions

### `clearOldBranches`

Cleans up local Git branches that have been deleted from the remote.

**What it does:**

1. Switches to `main`
2. Runs `git remote update origin --prune`
3. Finds branches marked as "gone" from remote
4. Deletes those local branches with `git branch -D`

**Usage:**

```bash
clearOldBranches
# or as a git alias:
git clearOldBranches
```

### Oh My Posh auto-initialization

`ohmyposh.sh` detects if `oh-my-posh` is installed and automatically initializes the prompt with the repo's theme. Guarded with `command -v` so it's silently skipped if Oh My Posh isn't present.

## Files

| File | Purpose |
|------|---------|
| `init.sh` | Main loader — sources all other `.sh` files |
| `git.sh` | Git-related functions (`clearOldBranches`) |
| `ohmyposh.sh` | Oh My Posh prompt initialization |
| `install.sh` | Installer (appends source line to rc files) |

## VS Code Integration

The workspace file (`dotfiles.code-workspace`) sets `BASH_ENV` to load shell config automatically in VS Code integrated terminals.
