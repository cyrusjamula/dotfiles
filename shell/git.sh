#!/bin/bash

# Git aliases and functions

# Function to clear old branches that have been deleted from remote
clearOldBranches() {
    echo "Switching to main branch..."
    git checkout main
    
    echo "Updating remote references and pruning..."
    git remote update origin --prune
    
    echo "Finding and deleting branches that are gone from remote..."
    git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D
    
    echo "Cleanup complete!"
}

# Export the function so it's available in the shell
export -f clearOldBranches
