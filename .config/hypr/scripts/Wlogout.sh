#!/usr/bin/env bash
# wlogout launcher with adaptive square buttons

if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Logical dimensions of the focused monitor (after Hyprland scaling)
read -r width height <<< "$(hyprctl -j monitors | jq -r '
  .[] | select(.focused==true) | "\((.width / .scale) | floor) \((.height / .scale) | floor)"
')"

# Number of buttons in your layout file
N=5

# Button size: 1/4 of screen height, clamped to a sane range
size=$(( height / 4 ))
(( size < 120 )) && size=120
(( size > 200 )) && size=200

# Center an NxN row on screen
T=$(( (height - size) / 2 ))
B=$T
L=$(( (width  - N * size) / 2 ))
R=$L

# Fallback if the screen is too narrow for N squares of this size
if (( L < 0 )); then
    L=20; R=20
    size=$(( (width - 40) / N ))
    T=$(( (height - size) / 2 ))
    B=$T
fi

# Prefer the locally patched build (hover moves keyboard focus) over the system one
WLOGOUT="$HOME/.local/bin/wlogout"
[ -x "$WLOGOUT" ] || WLOGOUT=wlogout

"$WLOGOUT" --protocol layer-shell -b $N -T $T -B $B -L $L -R $R &
