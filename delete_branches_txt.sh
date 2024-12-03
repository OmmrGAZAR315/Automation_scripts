#!/bin/bash
# File with branch names
branch_file="branches_to_delete.txt"

# Remote name, usually 'origin'
remote="origin"

# Loop through each branch and delete it from the remote
while IFS= read -r branch; do
  echo "Deleting branch: $branch"
  git push $remote --delete "$branch"
done < "$branch_file"

echo "All branches have been deleted."
