#!/usr/bin/env bash
# ==================================================
#  Project URL: https://github.com/LinuxBeginnings
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# For disabling touchpad.
# Device comes from TOUCHPAD_DEVICE (set in lua/env.lua), with auto-detection
# from `hyprctl devices` as fallback.
# source https://github.com/hyprwm/Hyprland/discussions/4283?sort=new#discussioncomment-8648109

set -euo pipefail

notif="$HOME/.config/swaync/images/ja.png"

touchpad_device="${TOUCHPAD_DEVICE:-}"
if [[ -z "$touchpad_device" ]]; then
    touchpad_device="$(hyprctl devices -j | jq -r '.mice[].name | select(endswith("touchpad"))' | head -n1)"
fi

if [[ -z "$touchpad_device" ]]; then
    notify-send -u low -i "$notif" " Touchpad" " No touchpad device found"
    exit 1
fi

status_file="${XDG_RUNTIME_DIR:-/tmp}/touchpad.status"

# hyprctl keyword is rejected by the Lua config provider; hl.device via eval
# is the working equivalent.
enable_touchpad() {
    printf "true" >"$status_file"
    notify-send -u low -i "$notif" " Enabling" " touchpad"
    hyprctl eval "hl.device({ name = '$touchpad_device', enabled = true })"
}

disable_touchpad() {
    printf "false" >"$status_file"
    notify-send -u low -i "$notif" " Disabling" " touchpad"
    hyprctl eval "hl.device({ name = '$touchpad_device', enabled = false })"
}

current_state="false"
if [[ -f "$status_file" ]]; then
    current_state="$(<"$status_file")"
fi

if [[ "$current_state" == "true" ]]; then
    disable_touchpad
else
    enable_touchpad
fi
