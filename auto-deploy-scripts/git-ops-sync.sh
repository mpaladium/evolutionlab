#!/bin/bash
# Paths
REPO_DIR="/path/to/repo-dir" #### Change Here
TARGET_DIR="/path/to/traefik/dynamic.yml"   #### Change Here
LOG_FILE="${PWD}/logs/sync.log"

# Timestamp
echo "[$(date)] Starting sync..." >> "$LOG_FILE"

# Go to repo
cd "$REPO_DIR" || exit

# Pull latest changes
git fetch origin main >> "$LOG_FILE" 2>&1
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "Changes detected. Pulling updates..." >> "$LOG_FILE"
    git pull origin main >> "$LOG_FILE" 2>&1

    SRC="$REPO_DIR/deployment.yml"
    DST="$TARGET_DIR/dynamic.yml"

    # Only copy if content differs
    if ! cmp -s "$SRC" "$DST"; then
        cp "$SRC" "$DST"
        echo "[$(date)] Config updated and Traefik will reload." >> "$LOG_FILE"
    else
        echo "[$(date)] No content change; skipping copy." >> "$LOG_FILE"
    fi
else
    echo "[$(date)] No new commits; nothing to do." >> "$LOG_FILE"
fi
