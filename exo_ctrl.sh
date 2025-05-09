#!/usr/bin/env bash
# Author: 4ndr0666
# Version: v0.4.2
set -euo pipefail
# =================== // TWIN_CTRL.SH //

## PYTHON PORT ____________________________________________________________________
    # import os, sys
    # from pathlib import Path
    #
    # exo_dir = Path(os.environ.get("XDG_DATA_HOME", str(Path.home() / ".local/share"))) / "twin"
    # map_file = exo_dir / "feature-map.txt"
    # exo_dir.mkdir(parents=True, exist_ok=True)
    #
    # query = " ".join(sys.argv[1:]).strip()
    # if not query:
    #     print("⚠️ Empty or invalid input. Logging...")
    #     # call exo_score.py here
    # ----------------------------------------------------------------------------

## Globals

TWIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/exocortex"
MAP_FILE="$TWIN_DIR/feature-map.txt"
mkdir -p "$TWIN_DIR"

## Project Path

rootpath() {
    local src="${BASH_SOURCE[0]:-$0}"
    [[ -L "$src" ]] && dirname "$(readlink "$src")" || dirname "$src"
}

## TRAP

TEMP_FILES=()
cleanup_all() {
    for f in "${TEMP_FILES[@]}"; do
        [[ -f "$f" ]] && rm -f "$f"
    done
}
trap 'cleanup_all' EXIT INT TERM ERR

## Validate

validate_input() {
    local input="$1"
    if [[ -z "$input" || "${input// /}" = "" ]]; then
        echo "⚠️ Empty or invalid input. Routing to feedback loop..."
        "$(rootpath)/exo_score.sh" "[undefined]"
        exit 0
    fi
}

## Fuzzy Matching

fuzzy_match() {
    if command -v fzf >/dev/null 2>&1; then
        echo "🧠 No direct match found. Launching fuzzy selector..."
        cut -d'|' -f1 "$MAP_FILE" | fzf --prompt="Twin command: "
    else
        echo "❌ fzf not installed. Routing to feedback loop..."
        "$(rootpath)/exo_score.sh" "$QUERY"
        exit 0
    fi
}

## Sanitize

sanitize_command() {
    local candidate="$1"
    if echo "$candidate" | grep -qE 'rm\s+-rf|:?\(\)\s*\{'; then
        echo "⚠️ Suspicious command detected. Logging attempt..."
        "$(rootpath)/exo_score.sh" "$QUERY"
        exit 0
    fi
}

## PYTHON PORT_________________________________________________
    # if not match:
    #     print("🧠 No direct match found. Launching fuzzy selector...")
    #     try:
    #         import subprocess
    #         choices = subprocess.check_output(f"cut -d'|' -f1 {map_file}", shell=True, text=True)
    #         selected = subprocess.run(["fzf", "--prompt=Twin command: "],
    #                                   input=choices, capture_output=True, text=True).stdout.strip()
    #         for line in map_file.open():
    #             if line.startswith(selected):
    #                 match = line.strip()
    #                 break
    #     except FileNotFoundError:
    #         print("❌ fzf not installed. Exiting.")
    #         sys.exit(1)
    # --------------------------------------------------------------

## Match Logic

execute_match() {
    local match="$1"
    sanitize_command "$match"
    echo "🎯 Found match: $match"
    eval "${match#*|}"
    "$(rootpath)/exo_score.sh" "$QUERY"
}

## PYTHON PORT___________________________________________________
    # match = None
    # with map_file.open() as f:
    #     for line in f:
    #         if line.lower().startswith(query.lower()):
    #             match = line.strip()
    #             break
    # if not match:
    #     selected = subprocess.run([...fzf logic...])
    #     if selected:
    #         for line in map_file:
    #             if line.startswith(selected):
    #                 match = line.strip()
    #                 break
    # if match:
    #     os.system(match.split('|', 1)[1].strip())
    #     call exo_score.py
    # else:
    #     call exo_score.py(query)
    # ___________________________________________________________________________________

## Main Entry Point

QUERY="$*"
validate_input "$QUERY"
match=$(grep -i -m 1 "^$QUERY[[:space:]]*|" "$MAP_FILE" || true)
if [[ -z "$match" ]]; then
    QUERY=$(fuzzy_match)
    match=$(grep -i -m 1 "^$QUERY[[:space:]]*|" "$MAP_FILE" || true)
    [[ -z "$match" ]] && {
        echo "❌ Nothing selected. Logging..."
        "$(rootpath)/exo_score.sh" "$QUERY"
        exit 0
    }
fi

execute_match "$match"
