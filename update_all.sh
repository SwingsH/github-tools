#!/bin/bash

# Define organization
ORG="{your_organization}"

# Define token, replace the TOKEN variable with a new GitHub token when the old one expires
# How to ? github.com -> Settings -> Developer settings -> Personal access tokens
TOKEN="{your_token}"

# Define destination directory
DEST_DIR="."

# Save the original root directory
ROOT_DIR=$(pwd)

# Fetch repository URLs
REPOS=$(curl -s -H "Authorization: token $TOKEN" "https://api.github.com/orgs/$ORG/repos?per_page=100" | jq -r '.[].clone_url')

# Clone each repository if it does not already exist
for REPO in $REPOS; do
    # Remove trailing '.git' if it exists
    REPO_NAME=$(basename -s .git "$REPO")
    REPO_DIR="$DEST_DIR/$REPO_NAME.git"

    # Ensure that we don't end up with '.git.git'
    REPO_DIR=$(echo "$REPO_DIR" | sed 's/\.git\.git$/.git/')

    if [ ! -d "$REPO_DIR" ]; then
        echo "Cloning $REPO_NAME..."
        git clone "https://$TOKEN@${REPO#https://}" "$REPO_DIR"
    else
        echo "$REPO_NAME already exists. Skipping clone."
    fi
done

# Update all existing repositories
for REPO_DIR in $DEST_DIR/*.git; do
    if [ -d "$REPO_DIR" ]; then
        REPO_NAME=$(basename "$REPO_DIR" .git)
        REPO_URL="https://$TOKEN@github.com/$ORG/$REPO_NAME.git"

        # Correct the REPO_URL if it ends with .git.git
        REPO_URL=$(echo "$REPO_URL" | sed 's/\.git\.git$/.git/')

        echo "Updating repository in $REPO_DIR..."
        cd "$REPO_DIR" || { echo "Failed to cd into $REPO_DIR"; exit 1; }

        # Check the current remote URL
        CURRENT_REMOTE_URL=$(git remote get-url origin)

        # Correct the remote URL if it ends with .git.git
        if [[ "$CURRENT_REMOTE_URL" == *".git.git" ]]; then
            CORRECT_REMOTE_URL=$(echo "$CURRENT_REMOTE_URL" | sed 's/\.git\.git$/.git/')
            echo "Correcting remote URL from $CURRENT_REMOTE_URL to $CORRECT_REMOTE_URL..."
            git remote set-url origin "$CORRECT_REMOTE_URL"
        fi

        # Fetch and pull updates from all branches
        echo "Fetching updates from all branches..."
        git fetch --all
        echo "Pulling updates from all branches..."
        git pull --all

        # Navigate back to the root directory
        cd "$ROOT_DIR" || { echo "Failed to cd back to $ROOT_DIR"; exit 1; }
    else
        echo "$REPO_DIR is not a valid directory."
    fi
done