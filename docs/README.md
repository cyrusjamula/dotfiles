# Documentation

Documentation and reusable examples for the dotfiles repository.

## Module Documentation

Each module has its own README with installation instructions and details:

- [Git Configuration](../git/README.md)
- [Shell Configuration](../shell/README.md)
- [Oh My Posh](../ohmyposh/README.md)
- [Copilot CLI Statusline](../copilot-statusline/README.md)
- [WinGet Bootstrap](../winget/README.md)

## Guides

- [Syncing with upstream](../SYNCING.md) — Keep a repository created from this template current.
- [Security policy](../SECURITY.md) — Report vulnerabilities and review the repository's security practices.

## Reusable Examples

- [`examples/template-sync.yml`](examples/template-sync.yml) — Drop-in GitHub Actions workflow for downstream repos created from this template, opens a PR when upstream changes. See [SYNCING.md](../SYNCING.md) for the full guide.

## Repository Overview

See the [root README](../README.md) for quick start, prerequisites, platform support, and the full feature list.

The [`dotfiles.code-workspace`](../dotfiles.code-workspace) file configures integrated Bash terminals and provides a **Load Dotfiles** task. The [Dev Container configuration](../.devcontainer/devcontainer.json) provides the same environment in VS Code Dev Containers and GitHub Codespaces.

Copilot and Squad integration lives in [`.copilot/`](../.copilot/), [`.squad/`](../.squad/), `.mcp.json`, and `.vscode/mcp.json`. These files configure reusable skills, team coordination, and MCP servers; they do not contain live credentials.
