#!/bin/bash

# Fetch latest updates from remote
git fetch --all

# Loop through each local branch
for branch in $(git branch --format="%(refname:short)"); do
  # Check if the branch is present on the remote
  if ! git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    # Branch not on remote, so delete it locally
    echo "Deleting unpushed branch: $branch"
    git branch -D "$branch"
  fi
done

echo "All unpushed local branches have been deleted."
