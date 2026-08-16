# Git Configuration

Git configuration with aliases, editor integration, and workflow defaults.

## Files

- `.gitconfig` - Main git configuration (user settings, aliases, tool configs)
- `install.sh` - Installation script for Linux/macOS/WSL (Bash)
- `install.ps1` - Installation script for Windows PowerShell

## Installation

### Linux/macOS/WSL

```bash
./install.sh
```

### Windows PowerShell

```powershell
.\install.ps1
```

The installer will:

1. Preserve an existing `.gitconfig`.
   - Bash creates a timestamped backup such as `.gitconfig.backup.20260517070000`, unless the file already resolves to this repository's configuration.
   - PowerShell writes `.gitconfig.backup`.
2. Create a symlink from the home-directory `.gitconfig` to this repository.
3. On Windows, copy the file instead if symbolic links are unavailable.

> [!IMPORTANT]
> The included `.gitconfig` contains the repository owner's name and email. Update the `[user]` section before installing if you are using this repository as a template.

## Configuration Highlights

### User Settings

- Name: Cyrus Jamula
- Email: cyrus@jamula.net
- Default branch: `main`

### Aliases

| Alias | Command | Alias | Command |
|-------|---------|-------|---------|
| `st` | status | `co` | checkout |
| `br` | branch | `ci` | commit |
| `ca` | commit -a | `cm` | commit -m |
| `cam` | commit -am | `cp` | cherry-pick |
| `df` | diff | `dc` | diff --cached |
| `lg` | log --oneline --decorate --all --graph | `ls` | log --stat |
| `pu` | push | `pl` | pull |
| `rb` | rebase | `rs` | reset |
| `sh` | stash | `sm` | submodule |
| `unstage` | reset HEAD -- | `last` | log -1 HEAD |
| `visual` | gitk | `clearOldBranches` | prune gone branches |

### Tool Integration

- **Editor:** VS Code (`code --wait`)
- **Diff tool:** VS Code
- **Merge tool:** VS Code

### Workflow Defaults

- `push.autoSetupRemote = true` — automatically tracks upstream on first push
- `push.default = simple` — pushes the current branch to its matching upstream
- `branch.autosetupmerge = always` — new branches auto-configure merge tracking
- `pull.rebase = false` — uses merge-based pulls by default
- `core.autocrlf = input` — normalize line endings on commit
- Git LFS configured for large file support

## Branch Cleanup

Run `git clearOldBranches` to switch to `main`, prune `origin`, and delete local branches whose tracked upstream is marked as gone.

> [!WARNING]
> This alias uses `git branch -D`, so unmerged commits on matching branches are discarded. Review `git branch -vv` before running it.

## Manual Installation

If you prefer not to use the install scripts:

```bash
# Linux/macOS/WSL
ln -sf /path/to/dotfiles/git/.gitconfig ~/.gitconfig
```

```powershell
# Windows PowerShell (requires admin or Developer Mode)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.gitconfig" -Target "C:\path\to\dotfiles\git\.gitconfig"
```

## Windows Notes

- **Symbolic links** require administrator privileges or Windows Developer Mode
- If unavailable, the installer copies the file instead (changes won't auto-sync)
- Enable Developer Mode: Settings → Privacy & Security → For developers → Developer Mode
- Re-run the installer after repository changes when using the copy fallback
