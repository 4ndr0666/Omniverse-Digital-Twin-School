#!/usr/bin/env bash
# Author: 4ndr0666
# Version: 0.4
# ===================== // VALIDATE_MAP.SH //
## Description: Validates all entries in feature-map.txt by checking:
#              - Command executable exists
#              - Feature label present
#              - Valid delimiter
#              - Command syntax appears valid
#              - Duplicate label detection
# ------------------------------------------------------------

## PYTHON PORT ___________________________________________________________
# from pathlib import Path
# import shutil
# seen = set()
# for line in map_file.open():
#     if '|' not in line:
#         warn("Missing delimiter")
#     key, cmd = line.split('|', 1)
#     key, cmd = key.strip(), cmd.strip()
#     if key in seen:
#         warn("Duplicate key")
#     seen.add(key)
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
declare -A seen_labels

while IFS= read -r line || [[ -n "$line" ]]; do
    ((total++))
    ### Empty Line Check

    if [[ -z "$line" || "${line// /}" == "" ]]; then
        echo "⚠ Line $total: Empty line"
        ((errors++))
        continue
    fi

    ### Delimiter check
    if [[ "$line" != *"|"* ]]; then
        echo "⚠ Line $total: Missing delimiter → '$line'"
        ((errors++))
        continue
    fi

    IFS='|' read -r label command <<< "$line"
    label=$(echo "$label" | xargs)
    command=$(echo "$command" | xargs)

    ### Empty label or command check
    if [[ -z "$label" || -z "$command" ]]; then
        echo "⚠ Line $total: Incomplete mapping → '$label | $command'"
        ((errors++))
        continue
    fi

    ### Duplicate label check
    if [[ -n "${seen_labels[$label]+_}" ]]; then
        echo "⚠ Line $total: Duplicate label '$label' (previously defined on line ${seen_labels[$label]})"
        ((errors++))
        continue
    else
        seen_labels["$label"]=$total
    fi

    ### Check if command is prompt: only
    if [[ "$command" =~ ^(prompt:) ]]; then
        echo "✔ Line $total: $label → (prompt only)"
        continue
    fi

    ### Extract command name and check if available
    bin="${command%% *}"
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
