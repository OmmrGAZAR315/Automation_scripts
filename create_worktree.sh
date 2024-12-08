#!/bin/bash
branch_path=$1
branch_name=$2
git worktree add "$branch_path" "$branch_name"

ln -s $(pwd)/.env "$branch_path"/
rm -rf "$branch_path"/storage && ln -s $(pwd)/storage "$branch_path"/

cp -r $(pwd)/vendor "$branch_path"/
rm -rf "$branch_path"/public && cp -R public "$branch_path"/

sudo chmod 777 -R "$branch_path"
