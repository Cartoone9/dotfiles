#!/usr/bin/env bash
# Toggle the GNOME Settings Wi-Fi panel — a live wifi window
# (auto-rescans while open, native password dialogs).
# gnome-control-center refuses to start when XDG_CURRENT_DESKTOP
# is not GNOME, so it is spoofed for this process only.
# pgrep/pkill match comm, which the kernel truncates to 15 chars.

if pgrep -x gnome-control-c >/dev/null; then
    pkill -x gnome-control-c
else
    exec env XDG_CURRENT_DESKTOP=GNOME gnome-control-center wifi
fi
