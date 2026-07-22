#!/bin/bash
SELECTED="$1"

if [ -z "$SELECTED" ]; then
    fd --hidden --exclude .cache --exclude .local/share/Trash --exclude node_modules --exclude .git . "$HOME" 2>/dev/null | sort
elif [ -d "$SELECTED" ]; then
    coproc ( xdg-open "$SELECTED" &>/dev/null )
else
    coproc ( xdg-open "$SELECTED" &>/dev/null )
fi
