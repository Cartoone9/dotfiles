#!/usr/bin/env bash
# ==================================================
#  Project URL: https://github.com/LinuxBeginnings
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# Script for keyboard backlights (if supported) using brightnessctl

# Get keyboard brightness
get_kbd_backlight() {
	echo $(brightnessctl -d '*::kbd_backlight' -m | cut -d, -f4)
}

# Get icon (freedesktop name; the level shows in the notification's value bar)
get_icon() {
	current=$(get_kbd_backlight | sed 's/%//')
	icon="keyboard-brightness-symbolic"
}
# Notify
notify_user() {
	notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:$current -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$icon" "Keyboard" "Brightness:$current%"
}

# Change brightness
change_kbd_backlight() {
	brightnessctl -d '*::kbd_backlight' set "$1" && get_icon && notify_user
}

# Execute accordingly
case "$1" in
	"--get")
		get_kbd_backlight
		;;
	"--inc")
		change_kbd_backlight "+30%"
		;;
	"--dec")
		change_kbd_backlight "30%-"
		;;
	*)
		get_kbd_backlight
		;;
esac
