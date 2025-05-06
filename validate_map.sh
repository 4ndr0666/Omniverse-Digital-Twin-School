#!/usr/bin/env bash
# Author: 4ndr0666
# Version: v0.1
# ===================== // TWIN MAP VALIDATOR //
## Description: Validates syntax, detects duplicates, confirms executables

## PYTHON PORT ___________________________________________________________
# from pathlib import Path
# import shutil
# seen = set()
# for line in map_file.open():
#     if not '|' in line:
#         warn("Missing delimiter")
#     key, cmd = line.split('|', 1)
#     if key in seen:
#         warn("Duplicate key")
#     if shutil.which(cmd.split()[0]) is None:
#         warn("Command not found")
# ________________________________________________________________________

## Globals

TWIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/twin"
MAP="$TWIN_DIR/feature-map.txt"

[[ ! -f "$MAP" ]] && { echo "❌ Map not found: $MAP"; exit 1; }

echo "🔍 Validating: $MAP"
echo "──────────────────────────────"

declare -A seen
errors=0
lineno=0

while IFS= read -r line; do
    lineno=$((lineno+1))
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Delimiter check
    if [[ "$line" != *"|"* ]]; then
        echo "⚠ Line $lineno: Missing delimiter (|)"
        errors=$((errors+1))
        continue
    fi

    key="${line%%|*}"
    cmd="${line#*|}"
    key="${key%"${key##*[![:space:]]}"}"     # trim trailing
    cmd="${cmd#"${cmd%%[![:space:]]*}"}"     # trim leading

    # Duplicate key check
    if [[ -n "${seen[$key]:-}" ]]; then
        echo "⚠ Line $lineno: Duplicate key → '$key'"
        errors=$((errors+1))
    fi
    seen["$key"]=1

    # Executable check
    bin="${cmd%% *}"
    if ! command -v "$bin" >/dev/null 2>&1 && [[ "$bin" != prompt:* ]]; then
        echo "⚠ Line $lineno: Command not found → '$bin'"
        errors=$((errors+1))
    fi

    echo "✔ Line $lineno: $key → $bin"
done < "$MAP"

echo "──────────────────────────────"
[[ "$errors" -eq 0 ]] && echo "✅ Map validation passed!" || echo "❌ $errors issue(s) found."
