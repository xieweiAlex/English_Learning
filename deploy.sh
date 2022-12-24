#!/bin/sh

# If a command fails then the deploy stops
set -e

set -e
set -e
set -e
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Default msg as current time 
date=$(date +'%m/%d/%Y %r')
msg="Changes at: $date"

if [ -n "$*" ]; then
	msg="$*"
fi
echo "$msg \n\n"

git commit -m "$msg"

# Push source and build repos.
git push origin master

