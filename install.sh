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

# ---------------------------------------------------------------- packages ---
install_packages() {
	msg "Enabling COPRs (Hyprland Lua build, SwayNC, lazygit)"
	sudo dnf copr enable -y sdegler/hyprland
	sudo dnf copr enable -y erikreider/SwayNotificationCenter
	sudo dnf copr enable -y atim/lazygit

	msg "Installing packages"
	sudo dnf install -y \
		hyprland hyprlock hypridle hyprpolkitagent waybar kitty swww \
		SwayNotificationCenter rofi wlogout \
		gnome-control-center gnome-keyring \
		grim slurp swappy wf-recorder wl-clipboard \
		playerctl brightnessctl pamixer libnotify jq \
		NetworkManager bluez util-linux python3 \
		zsh eza zoxide fzf fd-find atuin lazygit \
		cava btop htop mpv fastfetch \
		kvantum qt5ct qt6ct

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
		[[ $a == [yY] ]] && chsh -s "$(command -v zsh)"
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
}

# -------------------------------------------------------------------- main ---
if [ "$LINKS_ONLY" != --links-only ]; then
	install_packages
	install_fonts
	install_zsh
fi
install_links

if systemctl --user is-system-running &>/dev/null; then
	msg "Reloading systemd user units"
	systemctl --user daemon-reload
fi

msg "Done. Log out and pick Hyprland at the greeter (units in .config/systemd enable themselves via the tracked wants/ symlinks)."
msg "Reminder: .gitconfig carries my identity — edit [user] if you are not me."
