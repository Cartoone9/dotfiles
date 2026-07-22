# wlogout patches

## hover-grabs-focus.patch

Makes mouse hover grab keyboard focus on buttons (`enter-notify-event` +
`motion-notify-event` → `gtk_widget_grab_focus`). Combined with a `style.css`
that styles only `:focus` (not `:hover`), this yields a single highlight
overlay shared by mouse and keyboard — whichever input was used last moves it.

The patched binary lives at `~/.local/bin/wlogout`, which
`~/.config/hypr/scripts/Wlogout.sh` prefers over the system `/usr/bin/wlogout`.

### Rebuild (e.g. after a wlogout version bump)

```sh
git clone --branch 1.2.2 https://github.com/ArtsyMacaw/wlogout.git
cd wlogout
git apply ~/.config/wlogout/patches/hover-grabs-focus.patch
meson setup build -Dman-pages=disabled -Dbash-completions=false \
    -Dzsh-completions=false -Dfish-completions=false
ninja -C build
install -m755 build/wlogout ~/.local/bin/wlogout
```

Build deps: `gtk3-devel`, `gtk-layer-shell-devel`, `meson`, `ninja`.
