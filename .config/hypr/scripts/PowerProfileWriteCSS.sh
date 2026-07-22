#!/usr/bin/env bash
# Write swaync CSS marking the active power profile button.
# Reads current profile from D-Bus and writes nth-child highlight rule.

CSS_FILE="$HOME/.config/swaync/profile-state.css"

current=$(busctl get-property net.hadess.PowerProfiles \
    /net/hadess/PowerProfiles \
    net.hadess.PowerProfiles ActiveProfile 2>/dev/null \
    | awk -F'"' '{print $2}')

case "$current" in
    power-saver)  child=1 ;;
    balanced)     child=2 ;;
    performance)  child=3 ;;
    *)            child=0 ;;  # matches nothing, safely no-op
esac

cat > "$CSS_FILE" <<EOF
/* Auto-generated. Do not edit. Source: PowerProfileWriteCSS.sh */
.widget-buttons-grid>flowbox>flowboxchild:nth-child($child)>button {
    background: rgba(249, 38, 114, 0.15);
    color: #F92672;
    border: 1px solid rgba(249, 38, 114, 0.5);
}

.widget-buttons-grid>flowbox>flowboxchild:nth-child($child)>button:hover {
    background: rgba(249, 38, 114, 0.25);
    color: #F92672;
}
EOF

# Reload swaync CSS if it's running. Silently no-ops if not (e.g. early in login).
swaync-client --reload-css 2>/dev/null
