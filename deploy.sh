#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Commit changes.
date=$(date +'%m/%d/%Y %r')
msg="Changes at: $date"

echo "$msg \n\n"

if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

