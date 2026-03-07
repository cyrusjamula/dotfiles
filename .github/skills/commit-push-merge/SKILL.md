---
name: commit-push-merge
description: Commits all current changes, pushes the branch to the remote, and merges it into main. Use this when the user asks to check in, push, and merge their changes to main.
---

# Commit, Push, and Merge to Main

Follow these steps in order. Stop and report the error to the user if any step fails.

## Step 1: Validate state

1. Run `git status` to confirm there are staged or unstaged changes to commit. If the working tree is clean, inform the user there is nothing to commit and stop.
2. Run `git branch --show-current` to get the current branch name.
3. If already on `main`, warn the user and ask if they want to commit directly to main instead of merging. Do not proceed without confirmation.

## Step 2: Commit

1. Stage all changes: `git add -A`
2. Ask the user for a commit message. Suggest a concise message based on the changes if possible.
3. Commit with the provided message: `git commit -m "<message>"`

## Step 3: Push

1. Push the current branch to the remote: `git push`
2. If the branch has no upstream, use: `git push --set-upstream origin <branch-name>`

## Step 4: Merge to main

1. Switch to main: `git checkout main`
2. Pull latest: `git pull origin main`
3. Merge the feature branch: `git merge <branch-name>`
4. Push main: `git push origin main`

## Step 5: Cleanup

1. Ask the user if they want to delete the feature branch (both local and remote).
2. If yes:
   - Delete local: `git branch -d <branch-name>`
   - Delete remote: `git push origin --delete <branch-name>`
3. If no, switch back to the feature branch: `git checkout <branch-name>`

## Guidelines

- Always use `git --no-pager` for any commands that produce output.
- Never force-push (`--force`) unless the user explicitly requests it.
- If a merge conflict occurs, stop and inform the user. Do not attempt to auto-resolve conflicts.
- Include the Co-authored-by trailer in commits when Copilot helped write the changes.
