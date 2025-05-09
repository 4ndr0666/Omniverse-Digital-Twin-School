#!/usr/bin/env bash
# Author: 4ndr0666
# =================== // EXO_UI.SH //
## Description: 🧭 Interactive selector using whiptail
# ----------------------------

## PYTHON PORT ___________________________________________________________
# from pathlib import Path
# from prompt_toolkit.shortcuts import radiolist_dialog
# map_file = Path(os.environ.get("XDG_DATA_HOME", str(Path.home() / ".local/share"))) / "exocortex" / "feature-map.txt"
# options = [(line.split('|')[0].strip(), line.strip()) for line in map_file.open()]
# result = radiolist_dialog(
#     title="EXOCORTEX COMMAND SELECTOR",
#     text="Choose a task for your digital twin:",
#     values=options
# ).run()
# if result:
#     subprocess.run(["exocortex", result])
# ________________________________________________________________________

## 🔹 Path Resolution

rootpath() {
    local source="${BASH_SOURCE[0]:-$0}"
    if [[ -L "$source" ]]; then
        dirname "$(readlink "$source")"
    else
        dirname "$source"
    fi
}

### PYTHON PORT_____________________________
    # from pathlib import Path
    # root_path = Path(__file__).resolve().parent
    # ------------------------

## 🔹 Feature Map and Menu Construction

MAP="${XDG_DATA_HOME:-$HOME/.local/share}/exocortex/feature-map.txt"
OPTIONS=()

### PYTHON PORT___________________________________
    # with open(map_file) as f:
    #     options = [(line.split('|')[0].strip(), line.strip()) for line in f]
    # ------------------------------

while IFS='|' read -r label cmd; do
    OPTIONS+=("$label" "$cmd")
done < "$MAP"

## 🔹 Whiptail Menu & Dispatch

### PYTHON PORT__________________________________
    # from prompt_toolkit.shortcuts import radiolist_dialog
    # result = radiolist_dialog(
    #     title="EXOCORTEX COMMAND SELECTOR",
    #     text="Choose a task for your digital twin:",
    #     values=options
    # ).run()
    # --------------------------------

CHOICE=$(whiptail --title "EXOCORTEX COMMAND SELECTOR" \
                  --menu "Choose a task for your digital cortex:" 20 78 10 \
                  "${OPTIONS[@]}" \
                  3>&1 1>&2 2>&3)

if [[ -n "$CHOICE" ]]; then
    "$(rootpath)/exocortex" "$CHOICE"
else
    echo "⚠️ No selection made."
fi
