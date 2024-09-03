#!/bin/bash

# Set the local and remote repository details
LOCAL_REPO_PATH="D:/working/flutter_fitness_tracker_app_UI"
REPO_URL="https://github.com/keen429/flutter-fitness.git"
BASE_BRANCH="main"
REVIEWER="keen429"

# Navigate to the repository directory
cd "$LOCAL_REPO_PATH"

# Check if the directory exists and git is initialized
if [ ! -d ".git" ]; then
    echo "This directory is not a Git repository. Cloning the repository instead."
    git clone $REPO_URL "$LOCAL_REPO_PATH"
    cd "$LOCAL_REPO_PATH"
fi

# Authenticate GitHub CLI
gh auth login

# Loop to create 24 pull requests
for i in {1..24}
do
    # Create a new branch for each feature
    NEW_BRANCH="remove-comments-$i"
    git checkout -b $NEW_BRANCH $BASE_BRANCH

    # Remove comments from Dart files using sed
    find . -type f -name '*.dart' -exec sed -i '' -e '/\/\*/,/\*\//d' -e 's/\/\/.*$//' {} +

    # Add changes to git
    git add .

    # Commit the changes with a co-author
    git commit -m "Co-authored-by: keen429 <keen429@outlook.com>"

    # Push the new branch to GitHub
    git push origin $NEW_BRANCH

    # Create a pull request using GitHub CLI and set the reviewer
    gh pr create --base $BASE_BRANCH --head $NEW_BRANCH --title "Remove comments from feature $i" --body "Removed all comments from Dart files in feature $i" --reviewer $REVIEWER

    # Checkout back to the base branch
    git checkout $BASE_BRANCH
done