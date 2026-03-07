# dotfiles

Personal dotfiles repository to consolidate settings and configurations across Linux, macOS, WSL, and Windows.

## Contents

- [`git/`](git/) - Git configuration, aliases, and tool integration
- [`shell/`](shell/) - Shell functions and initialization (Bash/Zsh)
- [`ohmyposh/`](ohmyposh/) - Oh My Posh prompt theme and configuration
- [`docs/`](docs/) - Project documentation

## Quick Start

### Install Everything

**Linux/macOS/WSL:**

```bash
./install.sh
```

**Windows PowerShell:**

```powershell
.\install.ps1
```

### Install Individual Modules

Each module can be installed independently:

```bash
# Git configuration
cd git && ./install.sh

# Shell functions
cd shell && ./install.sh

# Oh My Posh prompt
cd ohmyposh && ./install.sh
```

## Prerequisites

- [Git](https://git-scm.com/) for version control configuration
- [Oh My Posh](https://ohmyposh.dev/) for the custom prompt theme
- [VS Code](https://code.visualstudio.com/) (optional) for diff/merge tool integration and the workspace file
- [Git LFS](https://git-lfs.com/) (optional) for large file support

## Structure

Each configuration module is organized in its own directory with:

- Configuration files (dotfiles)
- Installation scripts:
  - `install.sh` — Linux/macOS/WSL (Bash)
  - `install.ps1` — Windows PowerShell
- Documentation (`README.md`)

Installation scripts back up existing configs before creating symbolic links. On Windows, scripts fall back to file copying if symbolic links are unavailable.

## Features

### Git Configuration

Full Git setup including user settings, editor integration (VS Code), and workflow defaults like `autoSetupRemote` and LFS support.

**Aliases (40+):**

| Alias | Command | Alias | Command |
|-------|---------|-------|---------|
| `st` | status | `co` | checkout |
| `br` | branch | `ci` | commit |
| `ca` | commit -a | `cm` | commit -m |
| `cam` | commit -am | `cp` | cherry-pick |
| `df` | diff | `dc` | diff --cached |
| `lg` | log --oneline --graph | `ls` | log --stat |
| `pu` | push | `pl` | pull |
| `rb` | rebase | `rs` | reset |
| `sh` | stash | `sm` | submodule |
| `unstage` | reset HEAD -- | `last` | log -1 HEAD |

- **`clearOldBranches`** — Cleans up local branches deleted from remote (switches to main, prunes, deletes "gone" branches)

### Shell Functions

Shell scripts are auto-loaded by `shell/init.sh`, which sources every `.sh` file in the `shell/` directory on terminal startup.

- **`clearOldBranches`** — Git branch cleanup, available as a shell function
- **Oh My Posh initialization** — Automatically configures the custom prompt if `oh-my-posh` is installed

### Oh My Posh Theme

A custom two-line prompt theme with:

- **Left prompt:** Username, directory, Git branch/status, exit code
- **Right prompt:** Node.js, Go, Python indicators, shell name, current time
- **Tooltips:** AWS and Azure context when relevant
- SSH session awareness and a custom color palette

## VS Code Integration

Open `dotfiles.code-workspace` in VS Code for:

- Automatic shell configuration loading via `BASH_ENV`
- Integrated terminal with all dotfiles functions pre-loaded
- Build task to reload dotfiles (`Load Dotfiles`)

## Platform Support

| Platform | Status | Method |
|----------|--------|--------|
| **Linux** | ✅ Supported | Symbolic links |
| **macOS** | ✅ Supported | Symbolic links |
| **Windows WSL** | ✅ Supported | Symbolic links |
| **Windows PowerShell** | ✅ Supported | Symbolic links (admin/Developer Mode) or file copy fallback |

## License

This project is licensed under the [MIT License](LICENSE).

## Security

See [SECURITY.md](SECURITY.md) for vulnerability reporting guidelines.
