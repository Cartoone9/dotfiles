#!/usr/bin/env bash
# ~/.local/bin/rofi-wifi

set -euo pipefail

THEME="$HOME/.config/rofi/config-wifi.rasi"
PROMPT="󰤨  Wifi"
TERMINAL="kitty"
SEP="──────────────────────────"

signal_icon() {
    local s=${1:-0}

    if   (( s >= 75 )); then echo "󰤨"
    elif (( s >= 50 )); then echo "󰤥"
    elif (( s >= 25 )); then echo "󰤢"
    elif (( s >= 10 )); then echo "󰤟"
    else                    echo "󰤯"
    fi
}

notify_ok() {
    notify-send -u normal "WiFi" "$1"
}

notify_fail() {
    notify-send -u critical "WiFi failed" "$1"
}

ask_password() {
    rofi -dmenu -password \
        -theme "$THEME" \
        -theme-str 'window { width: 420px; } mainbox { children: [ inputbar ]; } entry { placeholder: "..."; }' \
        -p "Password" < /dev/null
}

# Parse nmcli -t lines while respecting escaped colons.
# nmcli escapes BSSID as AA\:BB\:CC..., so plain IFS=: is broken.
parse_nmcli_wifi_list() {
    awk '
        function split_escaped(s, arr,    i, c, esc, n) {
            n = 1
            arr[n] = ""
            esc = 0

            for (i = 1; i <= length(s); i++) {
                c = substr(s, i, 1)

                if (esc) {
                    arr[n] = arr[n] c
                    esc = 0
                    continue
                }

                if (c == "\\") {
                    esc = 1
                    continue
                }

                if (c == ":") {
                    n++
                    arr[n] = ""
                    continue
                }

                arr[n] = arr[n] c
            }

            return n
        }

        {
            delete f
            split_escaped($0, f)

            inuse = f[1]
            bssid = f[2]
            ssid  = f[3]
            sec   = f[4]
            sig   = f[5] + 0

            if (ssid == "" || bssid == "")
                next

            # Keep one entry per SSID:
            # - prefer the active AP
            # - otherwise prefer strongest signal
            if (!(ssid in seen)) {
                seen[ssid] = 1
                best_inuse[ssid] = inuse
                best_bssid[ssid] = bssid
                best_sec[ssid] = sec
                best_sig[ssid] = sig
            } else if (inuse == "*") {
                best_inuse[ssid] = inuse
                best_bssid[ssid] = bssid
                best_sec[ssid] = sec
                best_sig[ssid] = sig
            } else if (best_inuse[ssid] != "*" && sig > best_sig[ssid]) {
                best_inuse[ssid] = inuse
                best_bssid[ssid] = bssid
                best_sec[ssid] = sec
                best_sig[ssid] = sig
            }
        }

        END {
            for (ssid in seen) {
                printf "%s\t%s\t%s\t%s\t%s\n", best_inuse[ssid], best_bssid[ssid], best_sec[ssid], best_sig[ssid], ssid
            }
        }
    '
}

active_ssid() {
    nmcli -t -f ACTIVE,SSID dev wifi list --rescan no 2>/dev/null |
        awk '
            function split_escaped(s, arr,    i, c, esc, n) {
                n = 1
                arr[n] = ""
                esc = 0

                for (i = 1; i <= length(s); i++) {
                    c = substr(s, i, 1)

                    if (esc) {
                        arr[n] = arr[n] c
                        esc = 0
                        continue
                    }

                    if (c == "\\") {
                        esc = 1
                        continue
                    }

                    if (c == ":") {
                        n++
                        arr[n] = ""
                        continue
                    }

                    arr[n] = arr[n] c
                }

                return n
            }

            {
                delete f
                split_escaped($0, f)
                if (f[1] == "yes") {
                    print f[2]
                    exit
                }
            }
        '
}

active_wifi_iface() {
    nmcli -t -f DEVICE,TYPE,STATE device 2>/dev/null |
        awk -F: '$2 == "wifi" && $3 == "connected" { print $1; exit }'
}

wait_for_ssid() {
    local wanted="$1"
    local current

    for _ in {1..10}; do
        current=$(active_ssid)
        [[ "$current" == "$wanted" ]] && return 0
        sleep 1
    done

    return 1
}

connect_and_verify() {
    local ssid="$1"
    shift

    local output
    if ! output="$("$@" 2>&1)"; then
        notify_fail "$output"
        return 1
    fi

    if wait_for_ssid "$ssid"; then
        notify_ok "Connected to $ssid"
        return 0
    fi

    local current
    current=$(active_ssid)

    if [[ -n "$current" ]]; then
        notify_fail "Tried to connect to $ssid, but still connected to $current."
    else
        notify_fail "Tried to connect to $ssid, but no WiFi is active."
    fi

    return 1
}

disconnect_current_wifi() {
    local ssid="$1"
    local iface

    iface=$(active_wifi_iface)

    if [[ -z "$iface" ]]; then
        notify_fail "No active WiFi interface found."
        return 1
    fi

    if nmcli -w 10 dev disconnect "$iface" >/dev/null 2>&1; then
        notify_ok "Disconnected from $ssid"
    else
        notify_fail "Could not disconnect from $ssid"
        return 1
    fi
}

wifi_profile_uuid_for_ssid() {
    local wanted_ssid="$1"
    local uuid
    local profile_ssid

    while IFS= read -r uuid; do
        [[ -z "$uuid" ]] && continue

        profile_ssid=$(nmcli -g 802-11-wireless.ssid con show "$uuid" 2>/dev/null || true)

        if [[ "$profile_ssid" == "$wanted_ssid" ]]; then
            printf '%s\n' "$uuid"
            return 0
        fi
    done < <(
        nmcli -t -f UUID,TYPE con show 2>/dev/null |
            awk -F: '$2 == "802-11-wireless" { print $1 }'
    )

    return 1
}

forget_saved_network() {
    local -a entries
    local -a uuids

    local uuid
    local name
    local ssid
    local label

    while IFS= read -r uuid; do
        [[ -z "$uuid" ]] && continue

        name=$(nmcli -g connection.id con show "$uuid" 2>/dev/null || true)
        ssid=$(nmcli -g 802-11-wireless.ssid con show "$uuid" 2>/dev/null || true)

        [[ -z "$ssid" ]] && ssid="$name"
        [[ -z "$ssid" ]] && continue

        if [[ "$name" != "$ssid" && -n "$name" ]]; then
            label="$ssid  ($name)"
        else
            label="$ssid"
        fi

        entries+=("$label")
        uuids+=("$uuid")
    done < <(
        nmcli -t -f UUID,TYPE con show 2>/dev/null |
            awk -F: '$2 == "802-11-wireless" { print $1 }'
    )

    if (( ${#entries[@]} == 0 )); then
        notify_fail "No saved WiFi profiles found."
        return 1
    fi

    local sel
    sel=$(printf "%s\n" "${entries[@]}" |
        rofi -dmenu -i -format 'i' -theme "$THEME" -p "Forget WiFi")

    [[ -z "$sel" ]] && exit 0

    local confirm
    confirm=$(printf "No\nYes\n" |
        rofi -dmenu -i -theme "$THEME" -p "Forget ${entries[$sel]}?")

    [[ "$confirm" != "Yes" ]] && exit 0

    if nmcli con delete uuid "${uuids[$sel]}" >/dev/null 2>&1; then
        notify_ok "Forgot ${entries[$sel]}"
    else
        notify_fail "Could not forget ${entries[$sel]}"
        return 1
    fi
}

connect_visible_network() {
    local bssid="$1"
    local ssid="$2"
    local sec="$3"

    local uuid=""
    uuid=$(wifi_profile_uuid_for_ssid "$ssid" || true)

    if [[ -n "$uuid" ]]; then
        connect_and_verify "$ssid" nmcli -w 30 con up uuid "$uuid"
        return
    fi

    if [[ -n "$sec" && "$sec" != "--" ]]; then
        local pass
        pass=$(ask_password)
        [[ -z "$pass" ]] && exit 0

        connect_and_verify "$ssid" \
            nmcli -w 30 dev wifi connect "$bssid" password "$pass"
    else
        connect_and_verify "$ssid" \
            nmcli -w 30 dev wifi connect "$bssid"
    fi
}

# Rescan in background so the menu opens quickly.
nmcli dev wifi rescan >/dev/null 2>&1 &

declare -a display action

# --- Actions section ---
if [[ "$(nmcli radio wifi)" == "enabled" ]]; then
    display+=("󰖪  Disable WiFi")
    action+=("act:wifi_off")
else
    display+=("󰖩  Enable WiFi")
    action+=("act:wifi_on")
fi

display+=("󰑓  Rescan")
action+=("act:rescan")

display+=("󰌾  Connect to hidden")
action+=("act:manual")

display+=("󰛌  Forget saved network")
action+=("act:forget")

display+=("󰌘  Open nmtui")
action+=("act:settings")

display+=("$SEP")
action+=("sep")

# --- WiFi networks ---
mapfile -t nets < <(
    nmcli --terse --fields IN-USE,BSSID,SSID,SECURITY,SIGNAL dev wifi list --rescan no |
        parse_nmcli_wifi_list |
        sort -t $'\t' -k1,1r -k4,4nr
)

for net in "${nets[@]}"; do
    IFS=$'\t' read -r inuse bssid sec sigv ssid <<< "$net"

    icon=$(signal_icon "$sigv")

    lock=" "
    [[ -n "$sec" && "$sec" != "--" ]] && lock="󰌾"

    if [[ "$inuse" == "*" ]]; then
        display+=("✓ $icon $lock  $ssid")
        action+=("dis:${ssid}")
    else
        display+=("  $icon $lock  $ssid")
        action+=("con:${bssid}"$'\t'"${ssid}"$'\t'"${sec}")
    fi
done

# --- Show menu ---
sel=$(printf "%s\n" "${display[@]}" | rofi -dmenu -i -format 'i' -theme "$THEME" -p "$PROMPT")
[[ -z "$sel" ]] && exit 0

act="${action[$sel]}"

case "$act" in
    sep)
        exit 0
        ;;

    act:wifi_on)
        if nmcli radio wifi on; then
            notify_ok "WiFi enabled"
        else
            notify_fail "Could not enable WiFi"
        fi
        ;;

    act:wifi_off)
        if nmcli radio wifi off; then
            notify_ok "WiFi disabled"
        else
            notify_fail "Could not disable WiFi"
        fi
        ;;

    act:rescan)
        if nmcli dev wifi rescan; then
            notify_ok "Scan complete"
        else
            notify_fail "Scan failed"
        fi
        exec "$0"
        ;;

    act:manual)
        ssid=$(rofi -dmenu -theme "$THEME" -p "SSID:" < /dev/null)
        [[ -z "$ssid" ]] && exit 0

        pass=$(ask_password)

        if [[ -n "$pass" ]]; then
            connect_and_verify "$ssid" \
                nmcli -w 30 dev wifi connect "$ssid" password "$pass" hidden yes
        else
            connect_and_verify "$ssid" \
                nmcli -w 30 dev wifi connect "$ssid" hidden yes
        fi
        ;;

    act:forget)
        forget_saved_network
        ;;

    act:settings)
        "$TERMINAL" -e nmtui
        ;;

    dis:*)
        ssid="${act#dis:}"
        disconnect_current_wifi "$ssid"
        ;;

    con:*)
        payload="${act#con:}"
        IFS=$'\t' read -r bssid ssid sec <<< "$payload"

        connect_visible_network "$bssid" "$ssid" "$sec"
        ;;
esac
