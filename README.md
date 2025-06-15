# dotfiles
General dotfile repo used to consolidate all my personal settings and configurations

## Contents

- `git/` - Git configuration files and settings
- `shell/` - Shell configuration files (bash, zsh, etc.)

## Quick Start

Each directory contains installation scripts for different platforms:

### Git Configuration

**Linux/macOS/WSL:**
```bash
cd git/
./install.sh
```

**Windows PowerShell:**
```powershell
cd git
.\install.ps1
```

### All Dotfiles

**Linux/macOS/WSL:**
```bash
./install.sh
```

**Windows PowerShell:**
```powershell
.\install.ps1
```

## Structure

Each configuration type is organized in its own directory with:
- Configuration files (dotfiles)
- Installation scripts:
  - `install.sh` - Linux/macOS/WSL (Bash)
  - `install.ps1` - Windows PowerShell
- Documentation (`README.md`)

## Platform Support

- ✅ **Linux** - Full support with symbolic links
- ✅ **macOS** - Full support with symbolic links  
- ✅ **Windows WSL** - Full support with symbolic links
- ✅ **Windows PowerShell** - Supports symbolic links or file copying fallback
  - Symbolic links (requires admin privileges or Developer Mode)
  - File copying (fallback when symbolic links unavailable)
