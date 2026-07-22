#!/bin/bash
# Small indicator for windows hidden under a maximized window (ALT+F) on the
# active workspace. ALT+Tab or a click here cycles which window is on top.
# Outputs nothing when no window is maximized, so the module disappears.
#
# Event-driven: listens on Hyprland's socket2 and re-emits only when a
# relevant event fires, so waybar updates instantly instead of on a 1s poll.

# Material Design range only (same family as the battery icons, known to
# render in this bar); glyphs from other Nerd Font ranges can silently
# fall back to an invisible blank in GTK.
icon_for() {
    case "${1,,}" in
    kitty | alacritty | foot | *terminal*) echo "󰆍" ;;
    firefox* | librewolf | zen*) echo "󰈹" ;;
    chromium | *chrome* | brave*) echo "󰊯" ;;
    code* | *codium*) echo "󰨞" ;;
    *nautilus* | thunar | *files*) echo "󰉋" ;;
    discord | *vesktop*) echo "󰙯" ;;
    spotify*) echo "󰓇" ;;
    steam*) echo "󰓓" ;;
    mpv | vlc) echo "󰐊" ;;
    *obs*) echo "󰑋" ;;
    *telegram*) echo "󰒊" ;;
    *) echo "󰖲" ;;
    esac
}

compute() {
    local ws wsid empty='{"text": "", "class": "empty", "tooltip": false}'

    ws=$(hyprctl activeworkspace -j 2>/dev/null) || { echo "$empty"; return; }
    [ "$(jq -r '.hasfullscreen' <<<"$ws")" = "true" ] || { echo "$empty"; return; }
    wsid=$(jq -r '.id' <<<"$ws")

    # .fullscreen is an int on current Hyprland and a bool on older ones;
    # `// 0` maps both false and null to 0.
    local under
    mapfile -t under < <(hyprctl clients -j | jq -r --argjson ws "$wsid" \
        '.[] | select(.workspace.id == $ws and .mapped and (.fullscreen // 0) == 0) | "\(.class)\t\(.title)"')

    [ "${#under[@]}" -gt 0 ] || { echo "$empty"; return; }

    local icons="" tooltip="" entry class title
    for entry in "${under[@]}"; do
        IFS=$'\t' read -r class title <<<"$entry"
        icons+="$(icon_for "$class") "
        tooltip+="${class}: ${title}"$'\n'
    done

    jq -cn --arg text "${icons% }" --arg tooltip "under the maximized window:"$'\n'"${tooltip%$'\n'}" \
        '{text: $text, tooltip: $tooltip, class: "occupied"}'
}

last=""
emit() {
    local out
    out=$(compute)
    if [ "$out" != "$last" ]; then
        echo "$out"
        last=$out
    fi
}

emit

ncat -U "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
    while read -r event; do
        case $event in
        fullscreen* | openwindow* | closewindow* | movewindow* | workspace* | focusedmon* | windowtitle*)
            # coalesce event bursts (e.g. workspace switch fires several)
            while read -r -t 0.05 _; do :; done
            emit
            ;;
        esac
    done
