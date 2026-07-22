#!/bin/bash
rpm=$(sensors 2>/dev/null | awk '/fan1/{print $2; exit}')
rpm=${rpm:-0}

if [ "$rpm" -ge 4000 ]; then
    class="critical"
elif [ "$rpm" -ge 3000 ]; then
    class="high"
elif [ "$rpm" -ge 2200 ]; then
    class="warm"
else
    class="normal"
fi

printf '{"text": "<span color=\\"#888888\\">FAN</span> %srpm", "class": "%s"}\n' "$rpm" "$class"
