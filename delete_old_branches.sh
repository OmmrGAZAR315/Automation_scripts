#!/bin/bash

# Fetch the latest from the remote
git fetch --all

# Get the current date in seconds
current_date=$(date +%s)

# Number of seconds in one year (365 days)
one_year_in_seconds=$(( 182 * 24 * 60 * 60))

# Iterate over all local branches except the current one
for branch in $(git for-each-ref --format='%(refname:short) %(committerdate:unix)' refs/heads/ | awk -v current_date="$current_date" -v one_year_in_seconds="$one_year_in_seconds" '$2 < current_date - one_year_in_seconds {print $1}')
do
  if [ "$branch" != "$(git branch --show-current)" ]; then
    echo "branch: $branch" >> deleted_branches.txt
    # Uncomment the next line to actually delete the branch
#     git branch -D "$branch"
#     git push origin --delete "$branch"
  fi
done

echo "Completed deleting branches older than 6 Months."
