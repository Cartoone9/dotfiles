#!/usr/bin/env bash
# ==================================================
#  Project URL: https://github.com/LinuxBeginnings
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# Scripts for volume controls for audio and mic 

sDIR="$HOME/.config/hypr/scripts"

# Get Volume
get_volume() {
    if [[ "$(pamixer --get-mute)" == "true" ]]; then
        echo "Muted"
        return
    fi

    local volume
    volume=$(pamixer --get-volume)
    if [[ "$volume" -eq 0 ]]; then
        echo "Muted"
    else
        echo "$volume %"
    fi
}

# Get icons
get_icon() {
    if [[ "$(pamixer --get-mute)" == "true" ]]; then
        echo "audio-volume-muted-symbolic"
        return
    fi

    current=$(pamixer --get-volume)
    if [[ "$current" -le 30 ]]; then
        echo "audio-volume-low-symbolic"
    elif [[ "$current" -le 60 ]]; then
        echo "audio-volume-medium-symbolic"
    else
        echo "audio-volume-high-symbolic"
    fi
}

# Notify
notify_user() {
    local muted="$(pamixer --get-mute)"
    local level="$(pamixer --get-volume)"

    if [[ "$muted" == "true" || "$level" -eq 0 ]]; then
        notify-send -e -h string:x-canonical-private-synchronous:volume_notif \
            -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$(get_icon)" \
            " Volume:" " Muted"
    else
        notify-send -e -h int:value:"$level" -h string:x-canonical-private-synchronous:volume_notif \
            -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$(get_icon)" \
            " Volume Level:" " ${level}%" &&
            "$sDIR/Sounds.sh" --volume
    fi
}

# Increase Volume
inc_volume() {
    if [ "$(pamixer --get-mute)" == "true" ]; then
        toggle_mute
    else
        pamixer -i "$1" --set-limit 100 && notify_user
    fi
}

# Decrease Volume
dec_volume() {
    if [ "$(pamixer --get-mute)" == "true" ]; then
        toggle_mute
    else
        pamixer -d "$1" && notify_user
    fi
}

# Toggle Mute
toggle_mute() {
	if [ "$(pamixer --get-mute)" == "false" ]; then
		pamixer -m && notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "audio-volume-muted-symbolic" " Mute"
	elif [ "$(pamixer --get-mute)" == "true" ]; then
		pamixer -u && notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "$(get_icon)" " Volume:" " Switched ON"
	fi
}

# Toggle Mic
toggle_mic() {
	if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
		pamixer --default-source -m && notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "microphone-sensitivity-muted-symbolic" " Microphone:" " Switched OFF"
	elif [ "$(pamixer --default-source --get-mute)" == "true" ]; then
		pamixer --default-source -u && notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "microphone-sensitivity-high-symbolic" " Microphone:" " Switched ON"
	fi
}
# Get Mic Icon
get_mic_icon() {
    local muted="$(pamixer --default-source --get-mute)"
    local current="$(pamixer --default-source --get-volume)"
    if [[ "$muted" == "true" || "$current" -eq "0" ]]; then
        echo "microphone-sensitivity-muted-symbolic"
    else
        echo "microphone-sensitivity-high-symbolic"
    fi
}

# Get Microphone Volume
get_mic_volume() {
    if [[ "$(pamixer --default-source --get-mute)" == "true" ]]; then
        echo "Muted"
        return
    fi

    local volume
    volume=$(pamixer --default-source --get-volume)
    if [[ "$volume" -eq 0 ]]; then
        echo "Muted"
    else
        echo "$volume %"
    fi
}

# Notify for Microphone
notify_mic_user() {
    local muted="$(pamixer --default-source --get-mute)"
    local level="$(pamixer --default-source --get-volume)"
    local icon message

    if [[ "$muted" == "true" || "$level" -eq 0 ]]; then
        icon="microphone-sensitivity-muted-symbolic"
        notify-send -e -h "string:x-canonical-private-synchronous:volume_notif" \
            -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$icon" \
            " Mic Level:" " Muted"
    else
        icon="microphone-sensitivity-high-symbolic"
        notify-send -e -h int:value:"$level" -h "string:x-canonical-private-synchronous:volume_notif" \
            -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$icon" \
            " Mic Level:" " ${level}%"
    fi
}

# Increase MIC Volume
inc_mic_volume() {
    if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
        toggle_mic
    else
        pamixer --default-source -i 5 && notify_mic_user
    fi
}

# Decrease MIC Volume
dec_mic_volume() {
    if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
        toggle_mic
    else
        pamixer --default-source -d 5 && notify_mic_user
    fi
}

# Execute accordingly
case "$1" in
"--get")
  get_volume
  ;;
"--inc")
  inc_volume 5
  ;;
"--inc-precise")
  inc_volume 1
  ;;
"--dec")
  dec_volume 5
  ;;
"--dec-precise")
  dec_volume 1
  ;;
"--toggle")
  toggle_mute
  ;;
"--toggle-mic")
  toggle_mic
  ;;
"--get-icon")
  get_icon
  ;;
"--get-mic-icon")
  get_mic_icon
  ;;
"--mic-inc")
  inc_mic_volume
  ;;
"--mic-dec")
  dec_mic_volume
  ;;
*)
  get_volume
  ;;
esac
