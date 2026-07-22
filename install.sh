#!/usr/bin/env bash
# Symlink this repo's dotfiles into $HOME, backing up anything replaced to *.bak
set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
	local src=$1 dst=$2
	if [ -e "$dst" ] && [ ! -L "$dst" ]; then
		mv "$dst" "$dst.bak"
		echo "backed up $dst -> $dst.bak"
	fi
	ln -sfn "$src" "$dst"
	echo "linked $dst -> $src"
}

for f in .zshrc .p10k.zsh .gitconfig .clang-format; do
	link "$DOT/$f" "$HOME/$f"
done

mkdir -p "$HOME/.config"
for d in "$DOT"/.config/*/; do
	link "${d%/}" "$HOME/.config/$(basename "$d")"
done
