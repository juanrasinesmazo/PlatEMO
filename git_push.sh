#!/bin/bash

# Inputs
branch=master
message="$1"    # You must input a message string

# Change directory to local working repository
# cd /home/brendan/Desktop/AMME5060/Assignment2/ || return

# Track changes and omit external files
git add .
git rm -r --cached PlatEMO/Data/

# Showcase status
echo | git status

# Commit and push changes to remote branch
echo | git commit -m "$message"
echo | git push origin $branch




