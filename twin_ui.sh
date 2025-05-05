#!/usr/bin/env bash
# Author: 4ndr0666
# =================== // TWIN_UI.SH //
## Description: 🧭 Interactive selector using whiptail
# ----------------------------

## Constants

rootpath() {
    local source="${BASH_SOURCE[0]:-$0}"
    if [[ -L "$source" ]]; then
        dirname "$(readlink "$source")"
    else
        dirname "$source"
    fi
}
MAP="$XDG_DATA_HOME/twin/feature-map.txt"
OPTIONS=()

while IFS='|' read -r label cmd; do
    OPTIONS+=("$label" "$cmd")
done < "$MAP"

CHOICE=$(whiptail --title "TWIN COMMAND SELECTOR" \
                  --menu "Choose a task for your digital twin:" 20 78 10 \
                  "${OPTIONS[@]}" \
                  3>&1 1>&2 2>&3)

if [[ -n "$CHOICE" ]]; then
    $(rootpath)/twin.sh "$CHOICE"
else
    echo "⚠️ No selection made."
fi 
