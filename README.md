# dotfiles

Monokai-themed Hyprland setup on Fedora 44 — daily driven on a ThinkPad P14s Gen 5 (AMD).

<!-- Drop screenshots into assets/ and uncomment:
![desktop](assets/desktop.png)
![rofi](assets/rofi.png)
![terminal](assets/terminal.png)
-->

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

**No GNOME? Workaround included:** `waybar/scripts/rofi-wifi.sh` is a
self-contained nmcli + rofi wifi menu (scan, connect, forget, hidden SSID)
with no GNOME dependency — point the `custom/network` `on-click` in
`waybar/config.jsonc` at it instead. `networkmanager_dmenu` (installed by
`install.sh`, themed via `rofi/config-wifi.rasi`) is a third option.

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
`gnome-control-center` (wifi panel), `gnome-keyring` (secrets/ssh agent)

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

The full bootstrap enables the three COPRs, installs every dependency above
(including the GNOME pieces if your base lacks them), installs the Nerd Font
and the zsh stack, then symlinks everything into place — backing up anything
it would replace to `*.bak`. It links `.gitconfig` too, so edit the identity
in there if you are not me.

## Layout

The repo mirrors `$HOME`: `.zshrc`, `.p10k.zsh`, etc. at the root and one
directory per app under `.config/`. Everything on the machine is a symlink
into this repo, so a `git pull` updates the live config. systemd user units
live in `.config/systemd/user` with their `wants/` enablement symlinks
tracked, so they come pre-enabled.

## License

[MIT](LICENSE)
