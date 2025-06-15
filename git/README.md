# Git Configuration

This directory contains git configuration files and installation scripts.

## Files

- `.gitconfig` - Main git configuration file with user settings, aliases, and tool configurations
- `install.sh` - Installation script for Linux/macOS/WSL (Bash)
- `install.ps1` - Installation script for Windows PowerShell

## Installation

### Linux/macOS/WSL (Bash):
```bash
./install.sh
```

### Windows PowerShell:
```powershell
.\install.ps1
```

All installers will:
1. Backup your existing `.gitconfig` (if it exists) to `.gitconfig.backup`
2. Create a symlink from `~/.gitconfig` to this dotfiles version (or copy if admin privileges unavailable)

## Configuration Highlights

### User Settings
- Name: Cyrus Jamula
- Email: cyrus@jamula.net
- Default branch: main

### Useful Aliases
- `git st` - status
- `git co` - checkout
- `git br` - branch
- `git cm` - commit with message
- `git cam` - commit all with message
- `git lg` - pretty log graph
- `git unstage` - unstage files

### Tool Integration
- Editor: VS Code
- Diff tool: VS Code
- Merge tool: VS Code

## Manual Installation

If you prefer not to use the install scripts, you can manually create the symlink:

### Linux/macOS/WSL:
```bash
ln -sf /path/to/dotfiles/git/.gitconfig ~/.gitconfig
```

### Windows (Command Prompt - requires admin):
```cmd
mklink "%USERPROFILE%\.gitconfig" "C:\path\to\dotfiles\git\.gitconfig"
```

### Windows (PowerShell - requires admin):
```powershell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.gitconfig" -Target "C:\path\to\dotfiles\git\.gitconfig"
```

## Windows Notes

- **Symbolic links** require administrator privileges or Windows Developer Mode
- If you can't create symbolic links, the scripts will copy the file instead
- To enable Developer Mode: Settings > Update & Security > For developers > Developer Mode
