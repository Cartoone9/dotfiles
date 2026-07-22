# dotfiles

Monokai-themed Hyprland setup on Fedora 44, daily driven on a ThinkPad P14s Gen 5 (AMD).

<!-- intro video goes here -->

## Origin: Fedora Workstation → Hyprland

This started as a regular Fedora Workstation install with Hyprland added on
top, so it makes use of some GNOME plumbing that was already there:
`gnome-keyring` for secrets/ssh (started in `autostart.lua`), window rules
covering GNOME apps (Nautilus, Loupe, Calculator, File Roller...), and GNOME
Settings for the wifi menu (see below).

You don't need GNOME to use these dotfiles. The only GNOME package the
installer always pulls is `gnome-keyring` (3.5 MB). `gnome-control-center`
is optional: the installer asks if you want it for the wifi menu, and skips
it if you pick the rofi alternative. The window rules for GNOME apps simply
never match if the apps aren't installed. Any base works, Workstation is
just what I test on.

## The wifi menu trick

Clicking the network module in Waybar opens the actual GNOME Settings Wi-Fi
panel as a floating window (`waybar/scripts/wifi-settings.sh`):

- `gnome-control-center` refuses to start when `XDG_CURRENT_DESKTOP` is not
  GNOME, so the script spoofs it for that process only:
  `env XDG_CURRENT_DESKTOP=GNOME gnome-control-center wifi`
- a Hyprland window rule floats it centered at `600x880`. Below 600 px wide
  the libadwaita sidebar collapses, leaving a clean wifi-only popup
- you keep everything the panel does natively: live rescan, password
  dialogs, captive portals
- ESC closes it (the keybind only exists while the window is focused), and
  clicking the module again toggles it away

![wifi panel](assets/wifi.png)

No GNOME? `waybar/scripts/rofi-wifi.sh` is a self-contained nmcli + rofi
wifi menu (scan, connect, forget, hidden SSID) with no GNOME dependency.
`install.sh` asks which one you want and wires the Waybar click accordingly.
If `gnome-control-center` is already installed it goes with the GNOME panel
without asking. `networkmanager_dmenu` (installed by `install.sh`, themed
via `rofi/config-wifi.rasi`) is a third option.

## Footprint

Full Workstation on disk, but the running session is lean. Measured on my
machine (RSS, resident processes only):

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

The keyring is the only GNOME daemon running. No gnome-settings-daemon, no
tracker indexer, no evolution-data-server. A stock GNOME session idles well
past a gigabyte before you open anything; this sits around half that with
the full rice running. The GNOME wifi panel doesn't change any of this,
it's not a daemon and only runs while the window is open.

## Components

![desktop](assets/desktop.png)

| Role | Tool |
|---|---|
| Compositor | [Hyprland](https://hyprland.org/), Lua config provider build ([COPR `sdegler/hyprland`](https://copr.fedorainfracloud.org/coprs/sdegler/hyprland/)), configured in `.config/hypr/lua/` |
| Bar | Waybar |
| Notifications | SwayNC |
| Launcher | Rofi 2.0: app launcher, emoji picker, wifi/bluetooth menus |
| Terminal | kitty |
| Lock / idle | hyprlock / hypridle |
| Logout menu | wlogout, patched for a single hover/focus overlay (`.config/wlogout/patches/`) |
| Wallpaper | swww (Wayland wallpaper daemon), set at login by `hypr/scripts/WallpaperDaemon.sh`; the wallpaper ships in `.config/hypr/wallpapers/` |
| Shell | zsh + oh-my-zsh + powerlevel10k, atuin, zoxide, eza, fzf + fd |
| Theming | Monokai everywhere, accent `#F92672`: GTK 3/4, Qt (qt5ct/qt6ct + Kvantum), tridactyl |

### Terminal

kitty + zsh + powerlevel10k, with fastfetch, cava, and the `cdf` fuzzy
directory picker from `.zshrc`:

![terminal](assets/terminal.png)

### Launcher

Rofi with the Monokai accent:

![rofi](assets/rofi.png)

### Notifications

SwayNC control center: media player, radio toggles, volume and brightness
sliders:

![swaync](assets/swaync.png)

### Logout

wlogout with the single hover/focus overlay patch:

![wlogout](assets/wlogout.png)

### Firefox

tridactyl with the Monokai theme from `.config/tridactyl/themes`:

![tridactyl](assets/tridactyl.png)

## Dependencies

Everything below is what the configs and scripts actually call. `install.sh`
installs all of it.

**Core session** (COPR `sdegler/hyprland` unless noted):
`hyprland` (Lua provider build, the config will not parse on stock
Hyprland), `hyprlock`, `hypridle`, `hyprpolkitagent`, `waybar`, `kitty`,
`swww`, `SwayNotificationCenter` (COPR `erikreider`), `rofi` (2.0, Fedora),
`wlogout` (Fedora)

**GNOME plumbing** (preinstalled on Fedora Workstation):
`gnome-keyring` (secrets/ssh agent), `gnome-control-center` (optional, only
if you pick the GNOME wifi panel at install time)

**Script tooling:**
`grim`, `slurp`, `swappy`, `wf-recorder`, `wl-clipboard`, `playerctl`,
`brightnessctl`, `pamixer`, `libnotify`, `jq`, `NetworkManager`, `bluez`,
`util-linux` (rfkill), `python3`

**Shell & CLI:**
`zsh` (oh-my-zsh, powerlevel10k and zsh-syntax-highlighting are cloned by
the installer), `atuin`, `zoxide`, `eza`, `fzf`, `fd-find`, `lazygit`
(COPR `atim/lazygit`)

**Extras:**
`cava`, `btop`, `htop`, `mpv`, `fastfetch`, `kvantum` + `qt5ct` + `qt6ct`,
`networkmanager_dmenu` (not packaged for Fedora, the installer drops it in
`~/.local/bin`), tridactyl (Firefox extension; config and Monokai theme in
`.config/tridactyl`)

**Font:** JetBrainsMono Nerd Font (installer downloads it to
`~/.local/share/fonts`)

## Install

```sh
git clone https://github.com/Cartoone9/dotfiles ~/dotfiles
~/dotfiles/install.sh               # full bootstrap
~/dotfiles/install.sh --links-only  # just the symlinks
```

The full bootstrap asks which wifi menu you want (GNOME panel or rofi
script, the prompt explains the trade-off), enables the three COPRs,
installs the dependencies plus the Nerd Font and the zsh stack, then
symlinks everything into place. Anything it would replace is backed up to
`*.bak`. It links `.gitconfig` too, so edit the identity in there if you
are not me.

## Layout

The repo mirrors `$HOME`: `.zshrc`, `.p10k.zsh`, etc. at the root and one
directory per app under `.config/`. Everything on the machine is a symlink
into this repo, so a `git pull` updates the live config. systemd user units
live in `.config/systemd/user` with their `wants/` enablement symlinks
tracked, so they come pre-enabled.

## License

[MIT](LICENSE)
