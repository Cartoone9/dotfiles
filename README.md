# dotfiles

Monokai-themed Hyprland setup on Fedora 44 — daily driven on a ThinkPad P14s Gen 5 (AMD).

<!-- Drop screenshots into assets/ and uncomment:
![desktop](assets/desktop.png)
![rofi](assets/rofi.png)
![terminal](assets/terminal.png)
-->

## Components

| Role | Tool |
|---|---|
| Compositor | [Hyprland](https://hyprland.org/) — **Lua config provider** build ([COPR `sdegler/hyprland`](https://copr.fedorainfracloud.org/coprs/sdegler/hyprland/)), configured in `.config/hypr/lua/` |
| Bar | Waybar |
| Notifications | SwayNC |
| Launcher | Rofi (wayland) — app launcher, emoji picker, wifi/bluetooth menus |
| Terminal | kitty |
| Lock / idle | hyprlock / hypridle |
| Logout menu | wlogout, patched for a single hover/focus overlay (`.config/wlogout/patches/`) |
| Wallpaper | swww, driven by `hypr/scripts/WallpaperDaemon.sh` |
| Shell | zsh + oh-my-zsh + powerlevel10k, atuin, zoxide, eza, fzf + fd |
| Theming | Monokai everywhere, accent `#F92672` — GTK 3/4, Qt (qt5ct/qt6ct + Kvantum), tridactyl, the lot |
| Extras | cava, btop, htop, fastfetch, mpv, swappy, networkmanager-dmenu, tridactyl |

## Dependencies

```sh
sudo dnf copr enable sdegler/hyprland
sudo dnf install hyprland hyprlock hypridle waybar SwayNotificationCenter \
    rofi-wayland kitty wlogout swww \
    grim slurp swappy wf-recorder wl-clipboard \
    playerctl brightnessctl pamixer libnotify jq \
    NetworkManager bluez util-linux python3 \
    zsh eza zoxide fzf fd-find atuin
```

> **Note:** the Hyprland config is written in Lua and requires the Lua config
> provider build from the COPR above — it will not parse on a stock
> `hyprland.conf`-based install.

## Install

```sh
git clone https://github.com/Cartoone9/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

The installer symlinks each `.config/` directory and the top-level dotfiles
into place, backing up anything it would replace to `*.bak`. It links
`.gitconfig` too — edit the identity in there if you are not me.

## Layout

The repo mirrors `$HOME`: `.zshrc`, `.p10k.zsh`, etc. at the root and one
directory per app under `.config/`. Everything on the machine is a symlink
into this repo, so a `git pull` updates the live config.
