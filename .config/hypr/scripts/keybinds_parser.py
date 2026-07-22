#!/usr/bin/env python3
# Formats `hyprctl binds -j` (piped to stdin) into one line per bind for rofi.
import json
import sys

# X11 modifier mask bits as used by Hyprland's modmask field
MOD_BITS = [
    (64, "SUPER"),
    (8, "ALT"),
    (4, "CTRL"),
    (1, "SHIFT"),
    (2, "CAPS"),
    (16, "MOD2"),
    (32, "MOD3"),
    (128, "MOD5"),
]


def combo(bind):
    parts = [name for bit, name in MOD_BITS if bind["modmask"] & bit]
    key = bind["key"] or f"code:{bind['keycode']}"
    parts.append(key)
    return "+".join(parts)


def main():
    binds = json.load(sys.stdin)
    lines = []
    for b in binds:
        if b.get("submap"):
            continue
        desc = b.get("description", "")
        if not desc:
            # Lua binds are opaque ("__lua"); only show a raw dispatcher if it is meaningful
            dispatcher = b.get("dispatcher", "")
            arg = b.get("arg", "")
            desc = f"{dispatcher} {arg}".strip() if dispatcher != "__lua" else "(no description)"
        lines.append(f"{combo(b)} — {desc}")

    # Duplicate combos are real (e.g. one key firing two dispatchers): merge their descriptions
    merged = {}
    for line in lines:
        key, _, desc = line.partition(" — ")
        if key in merged and desc not in merged[key]:
            merged[key] = f"{merged[key]} + {desc}"
        else:
            merged.setdefault(key, desc)

    for key, desc in merged.items():
        print(f"{key} — {desc}")


if __name__ == "__main__":
    main()
