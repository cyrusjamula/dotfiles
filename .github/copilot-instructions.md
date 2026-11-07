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

**Shell auto-loading:** `shell/init.sh` sources every `*.sh` file in the `shell/` directory (except itself and `install.sh`). New shell functions are added by creating a new `.sh` file in `shell/` — no registration needed. Functions must be exported with `export -f` to be available in subshells.

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

<!-- squad:copilot-instructions:start -->
# Copilot Coding Agent — Squad Instructions

You are working on a project that uses **Squad**, an AI team framework. When picking up issues autonomously, follow these guidelines.

## Coordinator Canary Check

**IMPORTANT — run this check on EVERY session start, before doing any work:**

Inspect your `agent_instructions` for the coordinator canaries. This is a **two-state payload-integrity check within a known Squad coordinator session**; it verifies whether the coordinator payload loaded fully or was visibly truncated. It is **not** proof that an agent with no canaries is safely non-Squad — wholly absent payloads and proven non-Squad agents require a host-level identity beacon before custom-agent instruction ingestion.

1. If the HEAD canary `SQUAD_COORDINATOR_CANARY_HEAD_b7d2` is **absent**, the Squad coordinator payload is not observable from inside this prompt. Treat non-Squad discrimination as an **OPEN host-level concern**; do not claim this check proved the current agent is non-Squad.
2. If the HEAD canary `SQUAD_COORDINATOR_CANARY_HEAD_b7d2` is **present** and the EOF canary `SQUAD_COORDINATOR_CANARY_a8f3` is **present**, the coordinator prompt loaded fully. Proceed with normal Squad behavior.
3. If the HEAD canary `SQUAD_COORDINATOR_CANARY_HEAD_b7d2` is **present** but the EOF canary `SQUAD_COORDINATOR_CANARY_a8f3` is **absent**, the coordinator prompt loaded but was **truncated** before the end.

**When the coordinator prompt is truncated, you MUST:**
1. **STOP** — do not proceed with standard Squad behavior.
2. **WARN the user** with this exact message:
   ```
   ⚠️ Squad coordinator (squad.agent.md) loaded but appears to be truncated before the EOF canary. Do NOT proceed with standard Squad behavior — Squad's safety rails are incomplete. Please restart your session.
   ```
3. Do not continue with normal Squad routing, spawning, PR, or branch-protection behavior after emitting the warning.

## Team Context

Before starting work on any issue:

1. Read `.squad/team.md` for the team roster, member roles, and your capability profile.
2. Read `.squad/routing.md` for work routing rules.
3. If the issue has a `squad:{member}` label, read that member's charter at `.squad/agents/{member}/charter.md` to understand their domain expertise and coding style — work in their voice.

## Capability Self-Check

Before starting work, check your capability profile in `.squad/team.md` under the **Coding Agent → Capabilities** section.

- **🟢 Good fit** — proceed autonomously.
- **🟡 Needs review** — proceed, but note in the PR description that a squad member should review.
- **🔴 Not suitable** — do NOT start work. Instead, comment on the issue:
  ```
  🤖 This issue doesn't match my capability profile (reason: {why}). Suggesting reassignment to a squad member.
  ```

## Branch Naming

Use the squad branch convention:
```
squad/{issue-number}-{kebab-case-slug}
```
Example: `squad/42-fix-login-validation`

## PR Guidelines

When opening a PR:
- Reference the issue: `Closes #{issue-number}`
- If the issue had a `squad:{member}` label, mention the member: `Working as {member} ({role})`
- If this is a 🟡 needs-review task, add to the PR description: `⚠️ This task was flagged as "needs review" — please have a squad member review before merging.`
- Follow any project conventions in `.squad/decisions.md`

## Decisions

If you make a decision that affects other team members, write it to:
```
.squad/decisions/inbox/copilot-{brief-slug}.md
```
The Scribe will merge it into the shared decisions file.
<!-- squad:copilot-instructions:end -->
