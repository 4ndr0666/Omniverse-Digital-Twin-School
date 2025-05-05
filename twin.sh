#!/usr/bin/env bash
# Author: 4ndr0666
# ================== // 🧠 TWIN v0.1 — Modular Digital Twin Interface //
## Description: Logs input, maps to known feature
#               functions, scores feedback
# -----------------------------------------

rootpath() {
    local source="${BASH_SOURCE[0]:-$0}"
    if [[ -L "$source" ]]; then
        dirname "$(readlink "$source")"
    else
        dirname "$source"
    fi
}
INPUT="$*"
LOG_DIR="$XDG_DATA_HOME/twin/logs"
mkdir -p "$LOG_DIR"

echo "[$(date)] > $INPUT" >> "$LOG_DIR/$(date +%F).log"

$(rootpath)/twin_ctrl.sh "$INPUT"
