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
| Launcher | Rofi 2.0 — app launcher, emoji picker, wifi/bluetooth menus |
| Terminal | kitty |
| Lock / idle | hyprlock / hypridle |
| Logout menu | wlogout, patched for a single hover/focus overlay (`.config/wlogout/patches/`) |
| Wallpaper | swww, driven by `hypr/scripts/WallpaperDaemon.sh` |
| Shell | zsh + oh-my-zsh + powerlevel10k, atuin, zoxide, eza, fzf + fd |
| Theming | Monokai everywhere, accent `#F92672` — GTK 3/4, Qt (qt5ct/qt6ct + Kvantum), tridactyl, the lot |
| Extras | cava, btop, htop, fastfetch, mpv, swappy, networkmanager-dmenu, tridactyl |

## Install

```sh
git clone https://github.com/Cartoone9/dotfiles ~/dotfiles
~/dotfiles/install.sh               # full bootstrap
~/dotfiles/install.sh --links-only  # just the symlinks
```

The full bootstrap:
1. enables the COPRs (`sdegler/hyprland` for the Lua-provider Hyprland build
   + hyprlock/hypridle/waybar/kitty/swww, `erikreider/SwayNotificationCenter`,
   `atim/lazygit`) and installs every package the configs and scripts use
2. installs `networkmanager_dmenu` (not packaged for Fedora) to `~/.local/bin`
3. installs the JetBrainsMono Nerd Font
4. clones oh-my-zsh, powerlevel10k, and zsh-syntax-highlighting, and offers
   to make zsh your default shell
5. symlinks everything into place, backing up anything it would replace
   to `*.bak` — it links `.gitconfig` too, so edit the identity in there
   if you are not me

> **Note:** the Hyprland config is written in Lua and requires the Lua config
> provider build from the COPR above — it will not parse on a stock
> `hyprland.conf`-based install.

## Layout

The repo mirrors `$HOME`: `.zshrc`, `.p10k.zsh`, etc. at the root and one
directory per app under `.config/`. Everything on the machine is a symlink
into this repo, so a `git pull` updates the live config.
