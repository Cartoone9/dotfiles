#!/usr/bin/env bash
# Network + VPN status for Waybar — continuous, event-driven.
# Runs once (no "interval" in the module config): emits a JSON line at
# startup, on every NetworkManager event (bursts debounced), and at
# least every 20s as a signal-strength refresh.
# SSID and signal come from `iw` — live kernel values — because nmcli's
# `dev wifi list --rescan no` only returns NM's scan cache, which can be
# minutes old.
# Shows airplane icon only when AirplaneMode.sh created the state file,
# WiFi-off icon when WiFi is disabled normally,
# shield icon when VPN is active,
# WiFi strength icon otherwise.

STATE_FILE="/tmp/airplane-mode"

# a waybar reload leaks the previous instance (the old stdout pipe stays
# open, so it never gets a SIGPIPE) — replace any older self. Verify the
# match really is a script instance: pgrep -f alone would also hit an
# editor or shell whose command line merely mentions this path.
for pid in $(pgrep -f "waybar/scripts/network-vpn.sh"); do
    (( pid == $$ )) && continue
    [[ $(ps -o args= -p "$pid" 2>/dev/null) == bash\ *waybar/scripts/network-vpn.sh* ]] &&
        kill "$pid" 2>/dev/null
done

vpn_active() {
    ip link show 2>/dev/null | grep -qE 'proton|tun[0-9]|wg[0-9]|ipv6leak' && return 0
    nmcli -t connection show --active 2>/dev/null | grep -qi 'vpn' && return 0
    return 1
}

wifi_device() {
    nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null |
        awk -F: '$2 == "wifi" && $3 == "connected" { print $1; exit }'
}

signal_icon() {
    local s=${1:-0}

    if   (( s >= 75 )); then echo "󰤨"
    elif (( s >= 50 )); then echo "󰤥"
    elif (( s >= 25 )); then echo "󰤢"
    elif (( s >= 10 )); then echo "󰤟"
    else                    echo "󰤯"
    fi
}

json_escape() {
    printf '%s' "$1" | jq -Rsa .
}

emit() {
    local icon tooltip class dev iw_out ssid dbm signal wifi_icon

    if [[ -f "$STATE_FILE" ]]; then
        icon="󰀝"
        tooltip="Airplane mode"
        class="airplane"

    elif [[ "$(nmcli radio wifi 2>/dev/null)" == "disabled" ]]; then
        icon="󰖪"
        tooltip="WiFi disabled"
        class="wifi-off"

    elif dev=$(wifi_device) && [[ -n "$dev" ]]; then
        iw_out=$(iw dev "$dev" link 2>/dev/null)
        ssid=$(awk -F': ' '/^[[:space:]]*SSID:/ { print $2; exit }' <<<"$iw_out")
        dbm=$(awk '/^[[:space:]]*signal:/ { print $2; exit }' <<<"$iw_out")

        if [[ -n "$dbm" ]]; then
            # NM's own dBm→percent approximation
            signal=$(( 2 * (dbm + 100) ))
            (( signal > 100 )) && signal=100
            (( signal < 0 )) && signal=0
        else
            signal=0
        fi

        wifi_icon=$(signal_icon "$signal")

        if vpn_active; then
            icon="󰦝"
            tooltip="VPN active | $wifi_icon $ssid ($signal%)"
            class="vpn"
        else
            icon="$wifi_icon"
            tooltip="$ssid ($signal%)"
            class="connected"
        fi

    else
        icon="󰤭"
        tooltip="Disconnected"
        class="disconnected"
    fi

    printf '{"text": %s, "tooltip": %s, "class": "%s"}\n' \
        "$(json_escape "$icon")" \
        "$(json_escape "$tooltip")" \
        "$class"
}

trap 'pkill -P $$ 2>/dev/null; exit 0' TERM INT

emit
while true; do
    # stdbuf forces line buffering so events reach us immediately
    stdbuf -oL nmcli monitor 2>/dev/null | while true; do
        if read -r -t 20 _; then
            # emit right away, then coalesce the burst and emit again
            # with the settled state
            emit
            while read -r -t 0.3 _; do :; done
        elif (( $? <= 128 )); then
            break # EOF: nmcli monitor died (NM restart?)
        fi
        emit
    done
    emit
    sleep 5
done
