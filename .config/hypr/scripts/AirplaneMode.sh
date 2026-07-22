#!/usr/bin/env bash
# ==================================================
#  Project URL: https://github.com/LinuxBeginnings
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# Airplane Mode. Toggle wifi soft-block based on the real rfkill state,
# so it stays in sync across reboots (systemd-rfkill restores soft-block)
# and with changes made outside this script (nmcli, Fn key, etc.).
# The ON/OFF notification comes from rfkill-watch.sh, which owns it for
# every toggle source — do not notify here or it would double up.

if rfkill list wifi | grep -q "Soft blocked: yes"; then
    rfkill unblock wifi
else
    rfkill block wifi
fi

# Instant highlight feedback; rfkill-watch.sh re-syncs right after (idempotent).
"$HOME/.config/hypr/scripts/AirplaneWriteCSS.sh"
