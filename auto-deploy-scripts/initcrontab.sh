#!/bin/bash

# ----------------------------
# Cron job installer for git-ops-sync.sh
# ----------------------------

SYNC_SCRIPT="${PWD}/git-ops-sync.sh"
CRON_LOG="${PWD}/logs/cron-sync.log"
SETUP_LOG="${PWD}/logs/sync.log"
########## run the job weekly. every sunday 00:00 ####
CRON_LINE="0 0 * * 0 cd $PWD && $SYNC_SCRIPT >> $CRON_LOG 2>&1"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$SETUP_LOG"
}

# Step 1: Check if sync script exists and is executable
if [ ! -x "$SYNC_SCRIPT" ]; then
  log " ERROR: Sync script not found or not executable: $SYNC_SCRIPT"
  exit 1
else
  log "✔ Found executable sync script: $SYNC_SCRIPT"
fi

# Step 2: Check if cron job already exists (match by script path)
if crontab -l 2>/dev/null | grep -Fq "$SYNC_SCRIPT"; then
  log "⏭ Cron job already exists. Skipping addition."
else
  (crontab -l 2>/dev/null; echo "$CRON_LINE") | crontab -
  log "✅ Cron job added: $CRON_LINE"
fi

# Step 3: Show current crontab
log "📋 Current crontab:"
crontab -l | tee -a "$SETUP_LOG"
