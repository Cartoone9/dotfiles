# dotfiles

Monokai-themed Hyprland setup on Fedora 44 — daily driven on a ThinkPad P14s Gen 5 (AMD).

![desktop](assets/desktop.png)

| | |
|---|---|
| ![terminal](assets/terminal.png) | ![rofi](assets/rofi.png) |
| ![swaync](assets/swaync.png) | ![tridactyl](assets/tridactyl.png) |

![wlogout](assets/wlogout.png)

## Origin: Fedora Workstation → Hyprland

This config was not built on a minimal install — it is Hyprland layered on top
of **Fedora Workstation**, and it leans on the GNOME plumbing that base
provides: `gnome-keyring` (secrets/ssh, started in `autostart.lua`),
GNOME apps covered by the window rules (Nautilus, Loupe, Calculator,
File Roller…), and most notably GNOME Settings for the wifi menu (below).
The installer pulls in the GNOME pieces the config actually depends on, so it
also works from a non-Workstation base — but Workstation is the tested path.

## The wifi menu trick

Clicking the network module in Waybar does not open some hand-rolled nmcli
menu — it opens the **real GNOME Settings Wi-Fi panel** as a floating window
(`waybar/scripts/wifi-settings.sh`):

- `gnome-control-center` refuses to start when `XDG_CURRENT_DESKTOP` is not
  GNOME, so the script spoofs it **for that process only**:
  `env XDG_CURRENT_DESKTOP=GNOME gnome-control-center wifi`
- a Hyprland window rule floats it centered at `600x880` — at ≤ 600 px wide
  the libadwaita sidebar collapses, so you get a clean wifi-only popup
- you keep everything the panel does natively: live rescan while open,
  password dialogs, captive-portal handling — for free
- ESC closes it (a scoped keybind that only exists while the window is
  focused), and clicking the module again toggles it away

![wifi panel](assets/wifi.png)

**No GNOME? Workaround included:** `waybar/scripts/rofi-wifi.sh` is a
self-contained nmcli + rofi wifi menu (scan, connect, forget, hidden SSID)
with no GNOME dependency. **`install.sh` asks which one you want** — with
the pros and cons spelled out in the prompt — and wires the Waybar click
accordingly. If `gnome-control-center` is already on your system (any
Fedora Workstation base), it picks the GNOME panel automatically since the
heavy part is already paid for. `networkmanager_dmenu` (installed by
`install.sh`, themed via `rofi/config-wifi.rasi`) is a third option.

## Footprint

Layered on Workstation, but lean where it counts — at runtime. Measured on
the live system (RSS, resident processes only):

| | |
|---|---|
| Hyprland | 206 MB |
| swaync | 150 MB |
| waybar | 63 MB |
| hyprpolkitagent | 63 MB |
| pipewire + wireplumber | 46 MB |
| gnome-keyring | 9 MB |
| hypridle | 7 MB |
| swww-daemon | 3 MB |
| **whole desktop stack** | **~550 MB** |

Exactly **one** GNOME daemon is resident (the keyring). No
gnome-settings-daemon fleet, no tracker/localsearch indexer, no
evolution-data-server — none of the dbus-activated background services a
GNOME session drags in. A stock GNOME session idles well past a gigabyte
before the first app opens; this sits at half that with the full rice
running. The GNOME Settings wifi panel costs nothing here: it is not a
daemon, it only executes while the window is open.

## Components

| Role | Tool |
|---|---|
| Compositor | [Hyprland](https://hyprland.org/) — **Lua config provider** build ([COPR `sdegler/hyprland`](https://copr.fedorainfracloud.org/coprs/sdegler/hyprland/)), configured in `.config/hypr/lua/` |
| Bar | Waybar |
| Notifications | SwayNC |
| Launcher | Rofi 2.0 — app launcher, emoji picker, wifi/bluetooth menus |
| Terminal | kitty |
| Lock / idle | hyprlock / hypridle |
| Logout menu | wlogout, patched for a single hover/focus overlay (`.config/wlogout/patches/`) |
| Wallpaper | swww, driven by `hypr/scripts/WallpaperDaemon.sh` |
| Shell | zsh + oh-my-zsh + powerlevel10k, atuin, zoxide, eza, fzf + fd |
| Theming | Monokai everywhere, accent `#F92672` — GTK 3/4, Qt (qt5ct/qt6ct + Kvantum), tridactyl, the lot |

## Dependencies

Everything below is what the configs and scripts actually call — `install.sh`
installs all of it.

**Core session** (COPR `sdegler/hyprland` unless noted):
`hyprland` (Lua provider build — required, the config will not parse on stock
Hyprland), `hyprlock`, `hypridle`, `hyprpolkitagent`, `waybar`, `kitty`,
`swww`, `SwayNotificationCenter` (COPR `erikreider`), `rofi` (2.0, Fedora),
`wlogout` (Fedora)

**GNOME plumbing** (preinstalled on Fedora Workstation):
`gnome-keyring` (secrets/ssh agent, 3.5 MB), `gnome-control-center`
(**optional** — only if you pick the GNOME wifi panel at install time)

**Script tooling:**
`grim`, `slurp`, `swappy`, `wf-recorder`, `wl-clipboard`, `playerctl`,
`brightnessctl`, `pamixer`, `libnotify`, `jq`, `NetworkManager`, `bluez`,
`util-linux` (rfkill), `python3`

**Shell & CLI:**
`zsh` (+ oh-my-zsh, powerlevel10k, zsh-syntax-highlighting — cloned by the
installer), `atuin`, `zoxide`, `eza`, `fzf`, `fd-find`, `lazygit`
(COPR `atim/lazygit`)

**Extras:**
`cava`, `btop`, `htop`, `mpv`, `fastfetch`, `kvantum` + `qt5ct` + `qt6ct`,
`networkmanager_dmenu` (not packaged — installer drops it in `~/.local/bin`),
tridactyl (Firefox extension; config + Monokai theme in `.config/tridactyl`)

**Font:** JetBrainsMono Nerd Font (installer downloads it to
`~/.local/share/fonts`)

## Install

```sh
git clone https://github.com/Cartoone9/dotfiles ~/dotfiles
~/dotfiles/install.sh               # full bootstrap
~/dotfiles/install.sh --links-only  # just the symlinks
```

The full bootstrap asks which **wifi menu** you want (GNOME panel vs rofi
script — pros and cons shown in the prompt, auto-picks GNOME on a
Workstation base), enables the three COPRs, installs every dependency
above, installs the Nerd Font and the zsh stack, then symlinks everything
into place — backing up anything it would replace to `*.bak`. It links
`.gitconfig` too, so edit the identity in there if you are not me.

## Layout

The repo mirrors `$HOME`: `.zshrc`, `.p10k.zsh`, etc. at the root and one
directory per app under `.config/`. Everything on the machine is a symlink
into this repo, so a `git pull` updates the live config. systemd user units
live in `.config/systemd/user` with their `wants/` enablement symlinks
tracked, so they come pre-enabled.

## License

[MIT](LICENSE)
