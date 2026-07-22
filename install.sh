#!/usr/bin/env bash
# Bootstrap this dotfiles repo on a fresh Fedora machine.
#
#   ./install.sh              full install: packages, fonts, zsh, symlinks
#   ./install.sh --links-only only symlink the dotfiles into $HOME
#
# Symlinking backs up anything it would replace to *.bak — nothing is lost.
set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINKS_ONLY=${1:-}

msg() { printf '\033[1;35m==>\033[0m %s\n' "$*"; }

# --------------------------------------------------------------- wifi menu ---
# Clicking Waybar's network module opens a wifi menu. Two implementations ship
# with this repo; pick one at install time (see README, "The wifi menu trick").
WIFI_MENU=rofi

choose_wifi_menu() {
	if command -v gnome-control-center >/dev/null; then
		msg "GNOME Settings detected (Workstation base) — using it for the wifi menu"
		WIFI_MENU=gnome
		return
	fi
	if [ ! -t 0 ]; then
		msg "Non-interactive install — defaulting to the rofi wifi menu (no GNOME deps)"
		return
	fi
	cat <<-'EOF'

	Wifi menu — clicking the Waybar network module can open either:

	  1) GNOME Settings Wi-Fi panel (the trick this repo documents)
	       + full native UI: live rescan, password dialogs, captive portals,
	         enterprise auth — everything NetworkManager can do
	       + zero runtime cost: nothing resident, it only runs while open
	       - installs gnome-control-center: ~24 MB package plus GNOME libs,
	         on the order of ~120 MB on a minimal base

	  2) rofi wifi menu (pure nmcli + rofi, ships in this repo)
	       + zero extra dependencies, matches the rice's look
	       - basic by design: scan/connect/forget/hidden SSID only — no
	         captive-portal or enterprise-auth dialogs

	EOF
	local a
	read -rp "Pick your wifi menu [1=GNOME panel / 2=rofi] (default 2): " a
	if [ "${a:-2}" = 1 ]; then WIFI_MENU=gnome; else WIFI_MENU=rofi; fi
}

choose_main_mod() {
	[ -t 0 ] || return 0
	cat <<-'EOF'

	Main modifier: this config uses ALT as mainMod by design (window
	management on ALT, helpers like screenshots and the power menu on
	SUPER). If you prefer the traditional SUPER as main, the helper binds
	swap to ALT automatically, no collisions.

	EOF
	local a
	read -rp "Main modifier [1=ALT (default) / 2=SUPER]: " a
	if [ "${a:-1}" = 2 ]; then
		sed -i 's/^local mainMod = "ALT"/local mainMod = "SUPER"/' \
			"$DOT/.config/hypr/lua/binds.lua"
		msg "mainMod set to SUPER"
	fi
}

# ------------------------------------------------------------ git identity ---
# The tracked .gitconfig includes ~/.gitconfig.local for [user], so this repo
# carries no identity. Create that file here, prompting when we can.
setup_git_identity() {
	local f="$HOME/.gitconfig.local"
	if [ -e "$f" ]; then
		msg "Keeping your existing ~/.gitconfig.local"
		return
	fi

	local name='' email=''
	if [ -t 0 ] && [ "$LINKS_ONLY" != --links-only ]; then
		echo
		echo "Git identity — written to ~/.gitconfig.local, which stays out of"
		echo "this repo. Leave blank to fill it in yourself later."
		echo
		read -rp "  Name:  " name
		read -rp "  Email: " email
	fi

	local header='# Git identity for this machine. Not tracked by the dotfiles repo.'
	if [ -n "$name" ] || [ -n "$email" ]; then
		printf '%s\n[user]\n\tname = %s\n\temail = %s\n' \
			"$header" "$name" "$email" >"$f"
		msg "Wrote ~/.gitconfig.local for $name <$email>"
	else
		printf '%s\n# Fill these in — git will not commit until you do.\n[user]\n\tname =\n\temail =\n' \
			"$header" >"$f"
		msg "Wrote a ~/.gitconfig.local template — fill in [user] before committing"
	fi
}

wire_wifi_menu() {
	if [ "$WIFI_MENU" = rofi ]; then
		msg "Wiring the Waybar network click to rofi-wifi.sh"
		sed -i 's|scripts/wifi-settings.sh|scripts/rofi-wifi.sh|' \
			"$DOT/.config/waybar/config.jsonc"
	else
		msg "Keeping the GNOME Settings wifi panel (repo default)"
	fi
}

# ---------------------------------------------------------------- packages ---
install_packages() {
	msg "Enabling COPRs (Hyprland Lua build, SwayNC, lazygit)"
	sudo dnf copr enable -y sdegler/hyprland
	sudo dnf copr enable -y erikreider/SwayNotificationCenter
	sudo dnf copr enable -y atim/lazygit

	msg "Installing packages"
	sudo dnf install -y \
		hyprland hyprlock hypridle hyprpolkitagent waybar kitty swww \
		SwayNotificationCenter rofi wlogout gnome-keyring \
		grim slurp swappy wf-recorder wl-clipboard \
		playerctl brightnessctl pamixer libnotify jq \
		NetworkManager bluez util-linux python3 \
		lm_sensors nmap-ncat \
		zsh eza zoxide fzf fd-find atuin lazygit \
		cava btop htop mpv fastfetch \
		kvantum qt5ct qt6ct

	if [ "$WIFI_MENU" = gnome ] && ! command -v gnome-control-center >/dev/null; then
		msg "Installing gnome-control-center for the wifi panel"
		sudo dnf install -y gnome-control-center
	fi

	# networkmanager-dmenu is not packaged for Fedora — it is a single script
	if ! command -v networkmanager_dmenu >/dev/null; then
		msg "Installing networkmanager_dmenu to ~/.local/bin"
		mkdir -p "$HOME/.local/bin"
		curl -fsSL -o "$HOME/.local/bin/networkmanager_dmenu" \
			https://raw.githubusercontent.com/firecat53/networkmanager-dmenu/main/networkmanager_dmenu ||
		curl -fsSL -o "$HOME/.local/bin/networkmanager_dmenu" \
			https://raw.githubusercontent.com/firecat53/networkmanager-dmenu/master/networkmanager_dmenu
		chmod +x "$HOME/.local/bin/networkmanager_dmenu"
	fi
}

# ------------------------------------------------------------------- fonts ---
install_fonts() {
	if fc-list 2>/dev/null | grep -qi 'JetBrainsMono Nerd Font'; then
		msg "JetBrainsMono Nerd Font already installed"
		return
	fi
	msg "Installing JetBrainsMono Nerd Font"
	local dir="$HOME/.local/share/fonts/JetBrainsMonoNerd"
	mkdir -p "$dir"
	curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz |
		tar -xJ -C "$dir"
	fc-cache -f "$dir"
}

# --------------------------------------------------------------------- zsh ---
install_zsh() {
	local omz="$HOME/.oh-my-zsh"
	[ -d "$omz" ] || { msg "Cloning oh-my-zsh"; git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$omz"; }
	[ -d "$omz/custom/themes/powerlevel10k" ] ||
		{ msg "Cloning powerlevel10k"; git clone --depth 1 https://github.com/romkatv/powerlevel10k.git "$omz/custom/themes/powerlevel10k"; }
	[ -d "$omz/custom/plugins/zsh-syntax-highlighting" ] ||
		{ msg "Cloning zsh-syntax-highlighting"; git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$omz/custom/plugins/zsh-syntax-highlighting"; }

	if [ "$(basename "${SHELL:-}")" != zsh ] && [ -t 0 ]; then
		read -rp "Set zsh as your default shell? [y/N] " a
		# Not an && one-liner: declining would make this the function's exit
		# status and `set -e` would abort the install before anything is linked.
		if [[ $a == [yY] ]]; then
			chsh -s "$(command -v zsh)"
		fi
	fi
}

# ------------------------------------------------------------------- links ---
link() {
	local src=$1 dst=$2
	if [ -e "$dst" ] && [ ! -L "$dst" ]; then
		mv "$dst" "$dst.bak"
		echo "    backed up $dst -> $dst.bak"
	fi
	ln -sfn "$src" "$dst"
	echo "    linked $dst"
}

install_links() {
	msg "Symlinking dotfiles into \$HOME"
	for f in .zshrc .p10k.zsh .gitconfig .clang-format; do
		link "$DOT/$f" "$HOME/$f"
	done
	mkdir -p "$HOME/.config"
	for d in "$DOT"/.config/*/; do
		link "${d%/}" "$HOME/.config/$(basename "$d")"
	done

	# Point the wallpaper chain at the repo image unless one is already set.
	# -L as well as -e: a leftover symlink whose target is gone is still a
	# symlink, and a bare `ln -s` onto it fails and would abort the install.
	local wp="$HOME/.config/rofi/.current_wallpaper"
	if [ ! -e "$wp" ] && [ ! -L "$wp" ]; then
		ln -s "$DOT/.config/hypr/wallpapers/wallpaper_main.png" "$wp"
		echo "    linked $wp"
	fi
}

# -------------------------------------------------------------------- main ---
if [ "$LINKS_ONLY" != --links-only ]; then
	choose_wifi_menu
	choose_main_mod
	install_packages
	install_fonts
	install_zsh
fi
install_links
setup_git_identity
[ "$LINKS_ONLY" = --links-only ] || wire_wifi_menu

if systemctl --user is-system-running &>/dev/null; then
	msg "Reloading systemd user units"
	systemctl --user daemon-reload
fi

msg "Done. Log out and pick Hyprland at the greeter (units in .config/systemd enable themselves via the tracked wants/ symlinks)."
msg "Git identity lives in ~/.gitconfig.local — check it before your first commit."
