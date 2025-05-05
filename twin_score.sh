#!/usr/bin/env bash
# Author: 4ndr0666
# ===================== // TWIN_SCORE.SH //
## Description: 📈 TWIN FEEDBACK LOGGER
# ------------------------

## Constants

LOG="$XDG_DATA_HOME/twin/feedback.csv"
mkdir -p "$(dirname "$LOG")"
touch "$LOG"

read -rp "⭐ Was this helpful? [y/n]: " rating
read -rp "📝 Optional comment: " comment

timestamp=$(date +%F_%T)
echo "$timestamp,$1,$rating,\"$comment\"" >> "$LOG"

echo "✅ Feedback logged."
