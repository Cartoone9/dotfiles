#!/usr/bin/env bash
set -euo pipefail

# Power Bluetooth off at login and then sync the SwayNC Bluetooth button style.
# This avoids stale highlighted state when swaync loads before BlueZ state settles.

bluetoothctl power off >/dev/null 2>&1 || true

# Give BlueZ a short moment to settle before reading the powered state.
sleep 0.6

"${HOME}/.config/swaync/update-bluetooth-state.sh"
