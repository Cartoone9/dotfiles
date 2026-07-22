#!/usr/bin/env bash
CSS_FILE="$HOME/.config/swaync/airplane-state.css"

# Highlight when blocked either way (hard block = hardware radio switch).
if rfkill list wifi | grep -qE "(Soft|Hard) blocked: yes"; then
    cat > "$CSS_FILE" <<CSS
.widget-buttons-grid>flowbox>flowboxchild:nth-child(4)>button {
    background: rgba(249, 38, 114, 0.15);
    color: #F92672;
    border: 1px solid rgba(249, 38, 114, 0.5);
}
.widget-buttons-grid>flowbox>flowboxchild:nth-child(4)>button:hover {
    background: rgba(249, 38, 114, 0.25);
    color: #F92672;
}
CSS
else
    : > "$CSS_FILE"
fi

swaync-client --reload-css 2>/dev/null
