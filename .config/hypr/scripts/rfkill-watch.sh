#!/usr/bin/env bash
# Keep the swaync airplane/bluetooth button highlights in sync with reality.
# `rfkill event` prints one line per rfkill state change from ANY source
# (GNOME Settings, nmcli, Fn key, hardware switch) — each triggers a resync.
# Also the single owner of the airplane ON/OFF notification: it fires on any
# real wifi-block transition, so AirplaneMode.sh must NOT notify itself.
# Run as a systemd user service: rfkill-css-sync.service.

wifi_blocked() {
    rfkill list wifi | grep -qE "(Soft|Hard) blocked: yes"
}

sync_css() {
    "$HOME/.config/hypr/scripts/AirplaneWriteCSS.sh"
    "$HOME/.config/swaync/update-bluetooth-state.sh"
}

# Catch anything that changed before the watcher started (no notification —
# nothing transitioned, we're just learning the current state).
wifi_blocked && prev=on || prev=off
sync_css

rfkill event | while read -r _; do
    # One user action can emit several events (one per device); drain the
    # burst so swaync's CSS reloads once instead of three times.
    while read -r -t 0.3 _; do :; done
    sync_css
    wifi_blocked && cur=on || cur=off
    if [[ "$cur" != "$prev" ]]; then
        if [[ "$cur" == on ]]; then
            notify-send -u low -i airplane-mode-symbolic " Airplane" " mode: ON"
        else
            notify-send -u low -i airplane-mode-disabled-symbolic " Airplane" " mode: OFF"
        fi
        prev=$cur
    fi
done
