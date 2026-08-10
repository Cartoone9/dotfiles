#!/bin/bash
# Read fan RPM straight from the thinkpad_acpi hwmon (2 EC registers) instead
# of `sensors`, which sweeps every hwmon device (~12 EC reads per call)
for h in /sys/class/hwmon/hwmon*; do
    if [ "$(cat "$h/name" 2>/dev/null)" = "thinkpad" ]; then
        rpm=$(cat "$h/fan1_input" 2>/dev/null)
        break
    fi
done
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
