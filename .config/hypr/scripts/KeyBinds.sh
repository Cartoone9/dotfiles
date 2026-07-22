#!/usr/bin/env bash
# searchable list of the currently active keybinds using rofi
# Binds are read live from the compositor (hyprctl binds), so this always
# matches what lua/binds.lua actually registered.

rofi_theme="$HOME/.config/rofi/config-keybinds.rasi"
msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO function'

# check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

hyprctl binds -j | "$HOME/.config/hypr/scripts/keybinds_parser.py" \
  | rofi -dmenu -i -config "$rofi_theme" -mesg "$msg"
