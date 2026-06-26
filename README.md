# dotfiles

Personal dotfiles repository to consolidate settings and configurations across Linux, macOS, WSL, and Windows.

## Contents

- [`git/`](git/) - Git configuration, aliases, and tool integration
- [`shell/`](shell/) - Shell functions and initialization (Bash/Zsh)
- [`ohmyposh/`](ohmyposh/) - Oh My Posh prompt theme and configuration
- [`copilot-statusline/`](copilot-statusline/) - Copilot CLI statusline (Oh My Posh powered)
- [`winget/`](winget/) - WinGet bootstrap module for Windows
- [`.devcontainer/`](.devcontainer/) - Dev container / Codespaces configuration
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

# Copilot CLI statusline
cd copilot-statusline && ./install.sh

# WinGet bootstrap (Windows only)
cd winget && ./install.sh
```

## Prerequisites

- [Git](https://git-scm.com/) for version control configuration
- [Oh My Posh](https://ohmyposh.dev/) for the custom prompt theme and Copilot statusline
- [jq](https://jqlang.github.io/jq/) for the Copilot statusline installer (Linux/macOS)
- [VS Code](https://code.visualstudio.com/) (optional) for diff/merge tool integration and the workspace file
- [Git LFS](https://git-lfs.com/) (optional) for large file support
- A [Nerd Font](https://www.nerdfonts.com/) for powerline glyphs and icons
- [WinGet](https://learn.microsoft.com/windows/package-manager/winget/) (optional, Windows) for package management

## Structure

Each configuration module is organized in its own directory with:

- Configuration files (dotfiles)
- Installation scripts:
  - `install.sh` — Linux/macOS/WSL (Bash)
  - `install.ps1` — Windows PowerShell
- Documentation (`README.md`)

Installation scripts use `set -euo pipefail` for strict error handling, back up existing configs (with timestamps) before creating symbolic links, and skip re-linking if already configured. On Windows, scripts fall back to file copying if symbolic links are unavailable.

## Features

### Git Configuration

Full Git setup including user settings, editor integration (VS Code), and workflow defaults like `autoSetupRemote` and LFS support.

**Aliases:**

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

Shell scripts are auto-loaded by `shell/init.sh`, which sources every `.sh` file in the `shell/` directory on terminal startup (excluding `install.sh`). New functions are added by creating a new `.sh` file — no registration needed.

- **`clearOldBranches`** — Git branch cleanup, available as a shell function (exported for subshells)
- **Oh My Posh initialization** — Automatically configures the custom prompt if `oh-my-posh` is installed

### Oh My Posh Theme

A custom two-line prompt theme with:

- **Left prompt:** Username, directory, Git branch/status, exit code
- **Right prompt:** Node.js, Go, Python indicators, shell name, current time
- **Tooltips:** AWS and Azure context when relevant
- SSH session awareness and a custom color palette

### Copilot CLI Statusline

An Oh My Posh-powered statusline for [GitHub Copilot CLI](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line) that displays:

- Git branch and working tree status
- Runtime/language versions (Node.js, Go, Python)
- Context token usage with visual gauge
- Session duration
- Line changes (+added/-removed)

Based on [Scott Hanselman's gist](https://gist.github.com/shanselman/9623ac74888a07ba82f63f5310fda11b).

## VS Code Integration

Open `dotfiles.code-workspace` in VS Code for:

- Automatic shell configuration loading via `BASH_ENV`
- Integrated terminal with all dotfiles functions pre-loaded
- Build task to reload dotfiles (`Load Dotfiles`)
- GitHub Copilot and MCP server configuration
- GitHub Issues queries pre-configured

## Dev Container / Codespaces

The `.devcontainer/devcontainer.json` enables:

- **Ubuntu 24.04** base image with Git, GitHub CLI, Node.js, and PowerShell (`pwsh`) pre-installed
- **240-minute idle timeout** for Codespaces (vs. the 30-minute default)
- **GitHub Copilot CLI** (`copilot`) and **Squad CLI** (`squad`) installed globally via `postCreateCommand`
- Automatic dotfiles installation via `postCreateCommand`

Open this repo in a Codespace or VS Code Dev Container and everything is configured automatically.

## Platform Support

| Platform | Status | Method |
|----------|--------|--------|
| **Linux** | ✅ Supported | Symbolic links |
| **macOS** | ✅ Supported | Symbolic links |
| **Windows WSL** | ✅ Supported | Symbolic links |
| **Windows PowerShell** | ✅ Supported | Symbolic links (admin/Developer Mode) or file copy fallback |
| **GitHub Codespaces** | ✅ Supported | Dev container with auto-install |

## Adding a New Module

1. Create a directory at the repo root (e.g., `vim/`)
2. Add `install.sh` and `install.ps1` following the backup → symlink/copy pattern
3. Add a `README.md` describing the module
4. Register the module in both root `install.sh` and `install.ps1`
5. Update this README to document the new module

## License

This project is licensed under the [MIT License](LICENSE).

## Security

See [SECURITY.md](SECURITY.md) for vulnerability reporting guidelines.

## Using this as a Template

This repo is a [GitHub template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template). Click **Use this template** on GitHub to create your own dotfiles repo from it.

To **keep your downstream copy in sync** with upstream updates (manual or automated via a GitHub Action), see [SYNCING.md](SYNCING.md). An example sync workflow is included at [`docs/examples/template-sync.yml`](docs/examples/template-sync.yml).
