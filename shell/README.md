# Shell Configuration

Shell functions and initialization for Bash and Zsh. Auto-loads all `.sh` files in this directory on terminal startup.

## Installation

```bash
cd shell
./install.sh
```

The shell module has a Bash installer and is not installed by the root PowerShell script. It adds a `source` line pointing to `init.sh` in:

- `~/.bashrc` and `~/.bash_profile` when run from Bash
- `~/.zshrc` when Zsh is installed

Re-running the installer is safe: it detects the existing initialization, updates stale dotfiles paths, and consolidates duplicate entries.

After installation, restart the shell or run:

```bash
source ~/.bashrc
```

## How it works

`init.sh` sources every `*.sh` file in the `shell/` directory except itself and `install.sh`. It prints each loaded filename and a completion message. To add a new function, create a new `.sh` file — no registration is needed.

Functions are exported with `export -f` to be available in subshells.

## Available Functions

### `clearOldBranches`

Cleans up local Git branches that have been deleted from the remote.

**What it does:**

1. Switches to `main`
2. Runs `git remote update origin --prune`
3. Finds branches marked as "gone" from remote
4. Force-deletes those local branches with `git branch -D`

**Usage:**

```bash
clearOldBranches
# or as a git alias:
git clearOldBranches
```

> [!WARNING]
> The function uses `git branch -D`; review `git branch -vv` first if a branch may contain unmerged work.

### Oh My Posh auto-initialization

`ohmyposh.sh` detects if `oh-my-posh` is installed and automatically initializes the prompt with the repo's theme. Guarded with `command -v` so it's silently skipped if Oh My Posh isn't present.

## Files

| File | Purpose |
|------|---------|
| `init.sh` | Main loader — sources all other `.sh` files |
| `git.sh` | Git-related functions (`clearOldBranches`) |
| `ohmyposh.sh` | Oh My Posh prompt initialization |
| `install.sh` | Installer (appends source line to rc files) |

The loader excludes `install.sh`, so re-sourcing `init.sh` never runs the installer.

## VS Code Integration

The workspace file (`dotfiles.code-workspace`) sets `BASH_ENV` to load shell config automatically in VS Code integrated terminals.
