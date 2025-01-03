#!/bin/bash
branch_path=$1
branch_name=$2
git worktree add "$branch_path" "$branch_name"

if [ $? -ne 0 ]; then
    mkdir -p "$branch_path"
    rm -rf "$branch_path"/{*,.*}
    git ls-files | xargs -I files cp --parents files "$branch_path"
    cp -R .git "$branch_path"/
    git config --global --add safe.directory "$branch_path"
    echo "cp tracked files to successfully"
fi

cp $(pwd)/.env "$branch_path"/
rm -rf "$branch_path"/storage && ln -s $(pwd)/storage "$branch_path"/

cp -R $(pwd)/vendor "$branch_path"/
rm -rf "$branch_path"/public && cp -R public "$branch_path"/

sudo chmod 777 -R "$branch_path"
