#!/usr/bin/env bash
# ==================================================
#  Project URL: https://github.com/LinuxBeginnings
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# for changing Hyprland Layouts (master, dwindle, scrolling) on the fly
# Keybinds are static in lua/binds.lua; rebinding them here per layout fought
# the Lua binds and the winner depended on reload order.

layouts=(master dwindle scrolling)

get_layout() {
  hyprctl -j getoption general:layout | jq -r '.str'
}

next_layout() {
  local current="$1"
  local i
  for i in "${!layouts[@]}"; do
    if [[ "${layouts[i]}" == "$current" ]]; then
      echo "${layouts[((i + 1) % ${#layouts[@]})]}"
      return
    fi
  done
  echo "${layouts[0]}"
}

set_layout() {
  local target="$1"

  # hyprctl keyword is rejected by the Lua config provider; use eval
  hyprctl eval "hl.config({ general = { layout = '$target' } })"
  notify-send -e -u low -i input-keyboard-symbolic " ${target^} Layout"
}

current="$(get_layout)"
arg="${1:-toggle}"

case "$arg" in
toggle|next)
  set_layout "$(next_layout "$current")"
  ;;
master|dwindle|scrolling)
  set_layout "$arg"
  ;;
*)
  echo "Usage: $(basename "$0") [toggle|next|master|dwindle|scrolling]" >&2
  exit 1
  ;;
esac
