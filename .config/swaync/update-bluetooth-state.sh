#!/usr/bin/env bash
set -euo pipefail

CSS_FILE="${HOME}/.config/swaync/bluetooth-state.css"

is_bt_on() {
    local out
    out="$(bluetoothctl show 2>/dev/null || true)"
    [[ "$out" == *"Powered: yes"* ]]
}

if is_bt_on; then
    desired_css='/* Auto-generated. Do not edit. Source: update-bluetooth-state.sh */
.widget-buttons-grid>flowbox>flowboxchild:nth-child(5)>button {
    background: rgba(249, 38, 114, 0.15);
    color: #F92672;
    border: 1px solid rgba(249, 38, 114, 0.5);
}

.widget-buttons-grid>flowbox>flowboxchild:nth-child(5)>button:hover {
    background: rgba(249, 38, 114, 0.25);
    color: #F92672;
}
'
else
    desired_css='/* Auto-generated. Do not edit. Source: update-bluetooth-state.sh */
'
fi

current_css=""
if [[ -f "${CSS_FILE}" ]]; then
    current_css="$(cat "${CSS_FILE}")"
fi

if [[ "${current_css}" == "${desired_css%$'\n'}" ]]; then
    exit 0
fi

printf "%s" "${desired_css}" > "${CSS_FILE}"
# Reload swaync style if available.
swaync-client -rs >/dev/null 2>&1 || true
