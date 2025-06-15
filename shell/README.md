# Shell Configuration

This directory contains shell configuration files and functions for the dotfiles.

## Installation

Run the installation script to set up shell configuration:

```bash
./install.sh
```

This will add the dotfiles initialization to your shell configuration files (`.bashrc`, `.bash_profile`, `.zshrc`).

## Available Functions

### `clearOldBranches`

Cleans up local Git branches that have been deleted from the remote repository.

**What it does:**
1. Switches to the `main` branch
2. Updates remote references and prunes deleted branches
3. Finds local branches that are marked as "gone" from remote
4. Deletes those local branches

**Usage:**
```bash
clearOldBranches
```

**Git Alias:**
The same functionality is also available as a Git alias:
```bash
git clearOldBranches
```

## Files

- `init.sh` - Main loader that sources all shell configuration files
- `git.sh` - Git-related functions and aliases  
- `install.sh` - Installation script for shell configuration

## VS Code Integration

The workspace is configured to automatically load the shell configuration when opening terminals in VS Code. The `dotfiles.code-workspace` file contains the necessary settings.
