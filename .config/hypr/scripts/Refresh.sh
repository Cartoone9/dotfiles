#!/usr/bin/env bash
# ==================================================
#  Project URL: https://github.com/LinuxBeginnings
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# Scripts for refreshing waybar, rofi, swaync

# Close rofi so it picks up new config on next open
pidof rofi >/dev/null && pkill rofi

# Clean up any Waybar-spawned cava instances (unique temp conf names)
pkill -f 'waybar-cava\..*\.conf' 2>/dev/null || true

# Reload or start waybar once (owned by its systemd user unit)
if pidof waybar >/dev/null; then
  if command -v waybar-msg >/dev/null 2>&1; then
    waybar-msg cmd reload >/dev/null 2>&1 || true
  else
    killall -SIGUSR2 waybar 2>/dev/null || true
  fi
else
  systemctl --user start waybar.service
fi

# swaync is owned by its systemd user unit — reload in place, never restart here
swaync-client --reload-config 2>/dev/null || true
swaync-client --reload-css 2>/dev/null || true

exit 0
