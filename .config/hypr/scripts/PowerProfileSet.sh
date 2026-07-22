#!/usr/bin/env bash
profile="$1"
case "$profile" in
    performance|balanced|power-saver) ;;
    *) notify-send -a "Power Profile" "Invalid profile: $profile"; exit 1 ;;
esac

if busctl set-property net.hadess.PowerProfiles \
    /net/hadess/PowerProfiles \
    net.hadess.PowerProfiles \
    ActiveProfile "s" "$profile" 2>/dev/null; then
    case "$profile" in
        performance)  icon="󰓅" ;;
        balanced)     icon="󰾅" ;;
        power-saver)  icon="󰌪" ;;
    esac
    notify-send -a "Power Profile" "$icon  $profile"
    "$HOME/.config/hypr/scripts/PowerProfileWriteCSS.sh"
else
    notify-send -a "Power Profile" "Failed to set $profile"
fi
