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
# map_file = twin_dir / "feature-map.txt"
# log_file = twin_dir / "feedback.csv"
# twin_dir.mkdir(parents=True, exist_ok=True)
# log_file.touch(exist_ok=True)
# map_file.touch(exist_ok=True)
#
# query = sys.argv[1] if len(sys.argv) > 1 else "[undefined]"
# timestamp = datetime.now().isoformat()
#
# rating = input("⭐ Was this helpful? [y/n]: ").strip().lower()
# comment = input("📝 Optional comment: ")
#
# with log_file.open("a") as f:
#     f.write(f"{timestamp},{query},{rating},\"{comment}\"\n")
#
# if rating == "n":
#     print("🧠 Let's improve this mapping.")
#     new_cmd = input(f"🔁 What command should '{query}' execute instead? ").strip()
#     if new_cmd:
#         entry = f"{query} | {new_cmd}"
#         if entry not in map_file.read_text():
#             with map_file.open("a") as f:
#                 f.write(f"{entry}\n")
#             print("✅ Updated mapping saved to feature-map.txt")
#             with log_file.open("a") as f:
#                 f.write(f"{timestamp},[learned],{entry}\n")
#         else:
#             print("⚠️ Mapping already exists. No changes made.")
#     else:
#         print("⚠️ No command entered. Mapping unchanged.")
# print("✅ Feedback logged.")
# ------------------------------------------------------------------

## Globals

EXO_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/exocortex"
MAP_FILE="$EXO_DIR/feature-map.txt"
LOG_FILE="$EXO_DIR/feedback.csv"

mkdir -p "$EXO_DIR"
touch "$LOG_FILE" "$MAP_FILE"

## Query and Timestamp

QUERY="${1:-[undefined]}"
TIMESTAMP="$(date +%F_%T)"

## Prompt for Rating and Comment

read -rp "⭐ Was this helpful? [y/n]: " rating
read -rp "📝 Optional comment: " comment

## Log Feedback
echo "$TIMESTAMP,$QUERY,$rating,\"$comment\"" >> "$LOG_FILE"
## Learning and Remap Logic

if [[ "$rating" == "n" ]]; then
	echo "🧠 Let's improve this mapping."
	read -rp "🔁 What command should '$QUERY' execute instead? " new_cmd
	if [[ -n "$new_cmd" ]]; then
		entry="$QUERY | $new_cmd"

		if ! grep -Fxq "$entry" "$MAP_FILE"; then
			echo "$entry" >> "$MAP_FILE"
			echo "✅ Updated mapping saved to feature-map.txt"
			echo "$TIMESTAMP,[learned],$entry" >> "$LOG_FILE"
		else
			echo "⚠️ Mapping already exists. No changes made."
		fi
	else
		echo "⚠️ No command entered. Mapping unchanged."
	fi
fi

## Final Acknowledgement

echo "✅ Feedback logged."
