#!/usr/bin/env bash
# Author: 4ndr0666
# =================== // TWIN_CTRL.SH //
## Description: 🎛 TWIN Controller — Parses intent → action
# -----------------------------------


## Constants

rootpath() {
    local source="${BASH_SOURCE[0]:-$0}"
    if [[ -L "$source" ]]; then
        dirname "$(readlink "$source")"
    else
        dirname "$source"
    fi
}
TWIN_DIR="$(rootpath)"
MAP="$XDG_DATA_HOME/twin/feature-map.txt"
QUERY="$*"

match=$(grep -i "$QUERY" "$MAP" | head -n1 | cut -d'|' -f2- | xargs)

if [[ -n "$match" ]]; then
	echo "🎯 Found match: $match"
	eval "$match"
	"$TWIN_DIR/twin_score.sh" "$QUERY"
else
	echo "❌ No function mapped to: $QUERY"
fi
