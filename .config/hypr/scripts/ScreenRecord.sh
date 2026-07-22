#!/usr/bin/env bash

mkdir -p "$HOME/Videos"

if pgrep -x wf-recorder >/dev/null; then
    pkill -INT wf-recorder
    notify-send "Screen recording" "Stopped"
    exit 0
fi

output="$HOME/Videos/screen-$(date +%F-%H%M%S).mp4"

if [[ "$1" == "--full" ]]; then
    notify-send "Screen recording" "Started full screen"
    wf-recorder -f "$output"
else
    geom="$(slurp)" || exit 1
    notify-send "Screen recording" "Started area"
    wf-recorder -g "$geom" -f "$output"
fi
