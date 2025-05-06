#!/usr/bin/env bash
# Author: 4ndr0666
# ================== // 🧠 TWIN v0.1 — Modular Digital Twin Interface //
## Description: 📈 TWIN FEEDBACK LOGGER + LEARNING PATCH v0.4.2
# -----------------------------------------

## PYTHON PORT____________________________________________________
# import os, sys
# from pathlib import Path
# from datetime import datetime
#
# twin_dir = Path(os.environ.get("XDG_DATA_HOME", str(Path.home() / ".local/share"))) / "twin"
# log_file = twin_dir / "feedback.csv"
# log_file.parent.mkdir(parents=True, exist_ok=True)
# timestamp = datetime.now().isoformat()
# query = sys.argv[1] if len(sys.argv) > 1 else "[undefined]"
# rating = input("⭐ Was this helpful? [y/n]: ").strip().lower()
# comment = input("📝 Optional comment: ")
# if rating == "n":
#     new_cmd = input(f"🔁 What command should '{query}' execute instead? ").strip()
#     if new_cmd:
#         entry = f"{query} | {new_cmd}"
#         if entry not in map_file.read_text():
#             with map_file.open("a") as f:
#                 f.write(f"{entry}\\n")
# -------------------------------------------------------------

## Globals

TWIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/twin"
MAP_FILE="$TWIN_DIR/feature-map.txt"
LOG_FILE="$TWIN_DIR/feedback.csv"
mkdir -p "$TWIN_DIR"
touch "$LOG_FILE" "$MAP_FILE"

QUERY="${1:-[undefined]}"
TIMESTAMP="$(date +%F_%T)"

## Prompt

read -rp "⭐ Was this helpful? [y/n]: " rating
read -rp "📝 Optional comment: " comment
echo "$TIMESTAMP,$QUERY,$rating,\"$comment\"" >>"$LOG_FILE"

## Learning Logic

if [[ "$rating" == "n" ]]; then
	echo "🧠 Let's improve this mapping."
	read -rp "🔁 What command should '$QUERY' execute instead? " new_cmd
	if [[ -n "$new_cmd" ]]; then
		entry="$QUERY | $new_cmd"
		if ! grep -Fxq "$entry" "$MAP_FILE"; then
			echo "$entry" >>"$MAP_FILE"
			echo "✅ Updated mapping saved to feature-map.txt"
			echo "$TIMESTAMP,[learned],$entry" >>"$LOG_FILE"
		else
			echo "⚠️ Mapping already exists. No changes made."
		fi
	else
		echo "⚠️ No command entered. Mapping unchanged."
	fi
fi

echo "✅ Feedback logged."
