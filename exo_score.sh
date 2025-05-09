#!/usr/bin/env bash
# Author: 4ndr0666
# ===================== // EXO_SCORE.SH //
## Description: 📈 EXO FEEDBACK LOGGER + LEARNING PATCH v0.4
# ------------------------

# PYTHON PORT: ___________________________________________________________________________
# import os, sys
# from pathlib import Path
# from datetime import datetime
#
# exo_dir = Path(os.environ.get("XDG_DATA_HOME", str(Path.home() / ".local/share"))) / "twin"
# log_file = exo_dir / "feedback.csv"
# log_file.parent.mkdir(parents=True, exist_ok=True)
# timestamp = datetime.now().isoformat()
# query = sys.argv[1] if len(sys.argv) > 1 else "[undefined]"

### 🔹 Bash Globals

EXO_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/exo"
mkdir -p "$EXO_DIR"
LOG_FILE="$EXO_DIR/feedback.csv"
touch "$LOG_FILE"
QUERY="$1"
TIMESTAMP="$(date +%F_%T)"

### 🔹 Prompt for Rating and Comment

read -rp "⭐ Was this helpful? [y/n]: " rating
read -rp "📝 Optional comment: " comment

### 🔹 Log the Entry

echo "$TIMESTAMP,$QUERY,$rating,\"$comment\"" >> "$LOG_FILE"

### 🔹 If "No", Trigger Remapping Flow

if [[ "$rating" == "n" ]]; then
    echo "🧠 Let's improve this mapping."
    read -rp "🔁 What command should '$1' execute instead? " new_cmd
fi

### 🔹 Remap Suggestion and Deduplication

    if [[ -n "$new_cmd" ]]; then
        MAP_FILE="$EXO_DIR/feature-map.txt"
        ENTRY="$QUERY | $new_cmd"

        ### prevent dupes
        if ! grep -Fxq "$ENTRY" "$MAP_FILE"; then
            echo "$ENTRY" >> "$MAP_FILE"
            echo "✅ Updated mapping saved to feature-map.txt"
            echo "$TIMESTAMP,[learned],$ENTRY" >> "$LOG_FILE"
        else
            echo "⚠️ Mapping already exists. No changes made."
        fi
    else
        echo "⚠️ No command entered. Mapping unchanged."
    fi

### 🔹 Final Acknowledgement

echo "✅ Feedback logged."
