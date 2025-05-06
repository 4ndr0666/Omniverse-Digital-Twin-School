#!/usr/bin/env bash
# Author: 4ndr0666
# Version: 0.3
# ===================== // VALIDATE_MAP.SH //
## Description: Validates all entries in feature-map.txt by checking:
#              - Command executable exists
#              - Feature label present
#              - Command syntax appears valid
# ----------------------------------------------

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

MAP_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/twin/feature-map.txt"
[[ ! -f "$MAP_FILE" ]] && { echo "❌ Map file not found: $MAP_FILE"; exit 1; }

echo "🔍 Validating: $MAP_FILE"
echo "──────────────────────────────"

total=0
errors=0

while IFS='|' read -r label command; do
    ((total++))
    label=$(echo "$label" | xargs)
    command=$(echo "$command" | xargs)
    
    if [[ -z "$label" || -z "$command" ]]; then
        echo "⚠ Line $total: Incomplete mapping → '$label | $command'"
        ((errors++))
        continue
    fi

    bin="${command%% *}"
    
    if [[ "$bin" =~ ^(prompt:) ]]; then
        echo "✔ Line $total: $label → (prompt only)"
        continue
    fi

    if command -v "$bin" &>/dev/null; then
        echo "✔ Line $total: $label → $bin"
    else
        echo "⚠ Line $total: Command not found → '$bin'"
        ((errors++))
    fi
done < "$MAP_FILE"

echo "──────────────────────────────"
if [[ "$errors" -eq 0 ]]; then
    echo "✅ All $total entries are valid."
else
    echo "❌ $errors issue(s) found."
    exit 1
fi
