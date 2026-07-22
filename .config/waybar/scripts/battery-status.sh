#!/usr/bin/env bash
# Battery status for Waybar — continuous, event-driven.
# Runs once (no "interval" in the module config): emits a JSON line at
# startup, on every power_supply udev event (so AC plug/unplug shows at
# kernel speed — upowerd adds ~1-2s of settle lag, udev doesn't), and
# every 30s as a drain-rate refresh. Values come from sysfs; udev is
# only the wake-up source.
# Mirrors the built-in battery module it replaced: same icons, same
# 30/20 warning/critical thresholds, same "{timeTo}\n{power}W" tooltip.

BAT="/sys/class/power_supply/BAT0"
AC="/sys/class/power_supply/AC"

# a waybar reload leaks the previous instance (the old stdout pipe stays
# open, so it never gets a SIGPIPE) — replace any older self. Verify the
# match really is a script instance: pgrep -f alone would also hit an
# editor or shell whose command line merely mentions this path.
for pid in $(pgrep -f "waybar/scripts/battery-status.sh"); do
    (( pid == $$ )) && continue
    [[ $(ps -o args= -p "$pid" 2>/dev/null) == bash\ *waybar/scripts/battery-status.sh* ]] &&
        kill "$pid" 2>/dev/null
done

ICONS=(󰂎 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)

json_escape() {
    printf '%s' "$1" | jq -Rsa .
}

emit() {
    local cap status icon timeto classes class_json
    cap=$(cat "$BAT/capacity" 2>/dev/null || echo 0)
    status=$(cat "$BAT/status" 2>/dev/null || echo Unknown)

    local energy_now energy_full power_now power_w mins
    energy_now=$(cat "$BAT/energy_now" 2>/dev/null || echo 0)
    energy_full=$(cat "$BAT/energy_full" 2>/dev/null || echo 0)
    power_now=$(cat "$BAT/power_now" 2>/dev/null || echo 0)
    power_w=$(awk -v p="$power_now" 'BEGIN { printf "%.1f", p / 1e6 }')

    local idx=$(( cap / 10 ))
    (( idx > 10 )) && idx=10
    icon=${ICONS[idx]}

    timeto=""
    classes=()
    case "$status" in
        Charging)
            icon="󰂄"
            classes+=("charging")
            if (( power_now > 0 )); then
                mins=$(( (energy_full - energy_now) * 60 / power_now ))
                timeto=$(printf '%dh %02dmin until full' $((mins / 60)) $((mins % 60)))
            fi
            ;;
        Full)
            icon="󰁹"
            classes+=("charging" "full")
            timeto="Full"
            ;;
        "Not charging")
            classes+=("plugged")
            timeto="On AC (charge threshold)"
            ;;
        *)
            classes+=("discharging")
            if (( power_now > 0 )); then
                mins=$(( energy_now * 60 / power_now ))
                timeto=$(printf '%dh %02dmin until empty' $((mins / 60)) $((mins % 60)))
            fi
            ;;
    esac

    # state classes apply regardless of charging; CSS filters with :not(.charging)
    (( cap <= 30 )) && classes+=("warning")
    (( cap <= 20 )) && classes+=("critical")

    class_json=$(printf '"%s",' "${classes[@]}")
    class_json="[${class_json%,}]"

    printf '{"text": %s, "tooltip": %s, "class": %s}\n' \
        "$(json_escape "$icon $cap%")" \
        "$(json_escape "$timeto"$'\n'"${power_w}W")" \
        "$class_json"
}

trap 'pkill -P $$ 2>/dev/null; exit 0' TERM INT

emit
while true; do
    # stdbuf forces line buffering so events reach us immediately
    stdbuf -oL udevadm monitor -u -s power_supply 2>/dev/null | {
    timeout=30 settle=0
    while true; do
        if read -r -t "$timeout" _; then
            # emit right away — AC online flips instantly; the battery
            # status uevent that follows triggers its own emit
            emit
            while read -r -t 0.3 _; do :; done
            settle=8
        elif (( $? <= 128 )); then
            break # EOF: udevadm monitor died
        fi
        emit
        # on plug-in the EC flips "Not charging" -> "Charging" a few
        # seconds after the last uevent, with no uevent of its own —
        # re-poll at 1s until it lands (bounded: "Not charging" is a
        # steady state under charge thresholds). Unplug needs none of
        # this; the status flip arrives inside the event burst.
        status=$(cat "$BAT/status" 2>/dev/null)
        if (( settle > 0 )) && [[ $(cat "$AC/online" 2>/dev/null) == 1 &&
              $status != Charging && $status != Full ]]; then
            timeout=1
            (( settle-- ))
        else
            settle=0
            timeout=30
        fi
    done
    }
    emit
    sleep 5
done
