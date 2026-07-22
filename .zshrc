# Clear screen by printing empty lines
printf '\n%.0s' {1..$LINES}

# ======================================================================================
# PATH
# ======================================================================================
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# ======================================================================================
# Oh My Zsh
# ======================================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	git
	zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# Let topgrade handle updates; don't have OMZ prompt/check
zstyle ':omz:update' mode disabled

# ======================================================================================
# Editor
# ======================================================================================
export EDITOR='nvim'

# ======================================================================================
# Aliases
# ======================================================================================
alias g='git fetch --all --prune && git log --oneline --all --graph --decorate -n 50'
alias gs='git status'
alias ga='git add . && git status'
alias gc='git commit -m'
alias gp='git push'
alias gf='git fetch && git status'
alias gd="git difftool --no-symlinks --dir-diff"
alias gpu='git pull'
alias update='topgrade && echo && check'
alias vi='nvim'
alias ccw='cc -Wall -Werror -Wextra'
alias cl='printf "\n%.0s" {1..$LINES}'
alias cls='cl && ls'
alias cll='cl && ll'
alias clt='cl && lt'
alias ff='cl && fastfetch'
alias cfinit='printf -- "-std=c++98\n-Wall\n-Wextra\n-Werror\n-Ihdrs\n-Isrcs\n" > compile_flags.txt'
alias iginit='printf -- "*.o\n.objs\ncompile_flags.txt\n" >> .gitignore'
alias check='~/scripts/perso-check-repo/check-repo.zsh'
alias ssh='kitten ssh'
alias diff='kitten diff'
alias lg="lazygit"
alias vpnup='sudo wg-quick up proton'
alias vpndown='sudo wg-quick down proton'
alias vpnstatus='sudo wg show'

# ======================================================================================
# eza wrapper functions (replace ls/ll/lt/etc)
# ======================================================================================
unfunction ls 2>/dev/null
unalias ls 2>/dev/null
function ls() {
	command eza --icons --group-directories-first "$@"
}
unfunction ll 2>/dev/null
unalias ll 2>/dev/null
function ll() {
	command eza -l --icons --group-directories-first "$@"
}
unfunction l 2>/dev/null
unalias l 2>/dev/null
function l() {
	ll "$@"
}
unfunction lt 2>/dev/null
unalias lt 2>/dev/null
function lt() {
	command eza --tree --icons --group-directories-first "$@"
}
unfunction la 2>/dev/null
unalias la 2>/dev/null
function la() {
	command eza -la --icons --group-directories-first "$@"
}

# ======================================================================================
# Powerlevel10k config
# ======================================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ======================================================================================
# Profile (if present)
# ======================================================================================
if [ -f "$HOME/.profile" ]; then
	source "$HOME/.profile"
fi

# ======================================================================================
# Cached `<tool> init zsh` (atuin, zoxide)
# ======================================================================================
# Avoids spawning the tool on every shell start; regenerates the cache whenever the
# tool's binary is newer than the cache (i.e. after an update).
_cached_init() {
	local bin=${commands[$1]} cache=$HOME/.cache/zsh/init-$1.zsh
	[[ -n $bin ]] || return 1
	if [[ ! -r $cache || $bin -nt $cache ]]; then
		command mkdir -p ${cache:h}
		"$bin" init zsh > $cache 2>/dev/null || { command rm -f $cache; return 1 }
	fi
	source $cache
}

# ======================================================================================
# Zoxide
# ======================================================================================
[[ -f "$HOME/dotfiles/.zoxide.zsh" ]] && source "$HOME/dotfiles/.zoxide.zsh"

# ======================================================================================
# fd/fzf directory helpers
# ======================================================================================

# Shared appearance + matching for cdf/cdw/cdfa/cdd.
# Default fuzzy matching: "tragat" matches ~/42/ft_transcendence/services/gateway.
# Prefix a term with ' (e.g. 'tra) to require it as a literal substring instead.
# Ranking in cdf/cdw/cdd: fzf match score first ("nvi" puts ~/.config/nvim above a
# scattered-letter match in a frecent path), --tiebreak=index falls back to the
# frecency-ranked input order when scores are equal. --scheme=history makes every
# word-boundary bonus equal, so "trans" scores the same in ft_transcendence (after _)
# as in transport (after /) and frecency decides — the default scheme rates a match
# after / slightly higher and the tiebreak would never fire.
DIR_FZF_OPTS=(
	--border=rounded
	--height=100%
	--layout=default
	--info=inline
	'--color=fg:#f8f8f2,hl:#f92672'
	'--color=fg+:#f8f8f2,hl+:#fd971f'
	'--color=border:#494949,prompt:#66d9ef,pointer:#66d9ef'
	'--color=marker:#fd971f,spinner:#fd971f,info:#ae81ff'
)

# Directories/noisy trees ignored by cdf/cdw/cdfa
FD_EXCLUDES=(
	--exclude '.cache'
	--exclude '.mozilla'
	--exclude 'google-chrome*'
	--exclude 'chromium'
	--exclude 'node_modules'
	--exclude '.git'
	--exclude '.cargo'
	--exclude '.var'
	--exclude '.local'
	--exclude '.npm'
	--exclude '.pnpm-store'
	--exclude 'pkg/mod'
)

# Allow zsh glob exclusions like $HOME/^(Music|Pictures)(N/)
setopt EXTENDED_GLOB

# Main search roots for cdf/cdw.
# cdfa ignores this and searches all of $HOME.
if [[ "$(uname)" == "Darwin" ]]; then
	BASES=(
		$HOME/^(Music|Pictures|Videos|Movies|Library|Public|Applications|Creative Cloud Files)(N/)
		$HOME/.config(N/)
	)
else
	BASES=(
		$HOME/^(Music|Pictures|Videos|go)(N/)
		$HOME/.config(N/)
	)
fi

# Candidates for normal directory search: the bases themselves + their subdirectories
_cdf_candidates() {
	{
		print -rl -- "${BASES[@]}"
		fd --type d --hidden --no-ignore "${FD_EXCLUDES[@]}" . "${BASES[@]}" 2>/dev/null
	} | sed 's|/$||; /^$/d' | sort -u
}

# Reorder stdin paths: zoxide-visited dirs first (most used on top), then
# never-visited ones ordered shallowest-first so likely destinations beat
# deeply nested noise
_cdf_frecency_rank() {
	awk -v zlist=<(zoxide query -l 2>/dev/null) '
		BEGIN { while ((getline line < zlist) > 0) rank[line] = ++n }
		$0 in rank { printf "0\t%08d\t%s\n", rank[$0], $0; next }
		           { printf "1\t%08d\t%s\n", gsub("/", "/"), $0 }
	' | sort -t$'\t' -k1,1 -k2,2 -k3,3 | cut -f3-
}

# Search useful/project directories from BASES, most-used first (zoxide frecency)
cdf() {
	local dir
	dir=$(
		_cdf_candidates \
			| _cdf_frecency_rank \
			| sed "s|^$HOME|~|" \
			| fzf "${DIR_FZF_OPTS[@]}" \
				--border-label=cdf \
				--scheme=history \
				--tiebreak=index \
				--bind 'esc:abort' \
				--query "${*:-}" \
				--preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
				--preview-window=right:50%:wrap
	)

	[[ -n "$dir" ]] && cd "${dir/#\~/$HOME}"
}

# Search useful/project directories from BASES, then open nvim
cdw() {
	local dir
	dir=$(
		_cdf_candidates \
			| _cdf_frecency_rank \
			| sed "s|^$HOME|~|" \
			| fzf "${DIR_FZF_OPTS[@]}" \
				--border-label=cdw \
				--scheme=history \
				--tiebreak=index \
				--bind 'esc:abort' \
				--query "${*:-}" \
				--preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
				--preview-window=right:50%:wrap
	)

	[[ -n "$dir" ]] && cd "${dir/#\~/$HOME}" && vi
}

# Zoxide-ranked directory picker, restricted to the same roots as cdf
cdd() {
	local dir
	local query="${*:-}"

	dir=$(
		zoxide query -l 2>/dev/null \
			| sed "s|^$HOME|~|" \
			| fzf "${DIR_FZF_OPTS[@]}" \
				--border-label=cdd \
				--scheme=history \
				--tiebreak=index \
				--bind 'esc:abort' \
				--query "$query" \
				--preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
				--preview-window=right:50%:wrap
	)

	[[ -n "$dir" ]] && cd "${dir/#\~/$HOME}"
}

# Search all directories under $HOME, including hidden/ignored ones except FD_EXCLUDES
cdfa() {
	local dir

	dir=$(
		fd . ~ \
			--type d \
			--hidden \
			--no-ignore \
			"${FD_EXCLUDES[@]}" \
			| sed "s|^$HOME|~|" \
			| fzf "${DIR_FZF_OPTS[@]}" \
				--border-label=cdfa \
				--bind 'esc:abort' \
				--preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
				--preview-window=right:50%:wrap
	)

	[[ -n "$dir" ]] && cd "${dir/#\~/$HOME}"
}

# ======================================================================================
# fzf helpers
# ======================================================================================
fh() {
	eval "$(fc -l 1 | fzf --bind 'esc:abort' --tac --no-sort +s --preview 'echo {}' | sed 's/^[0-9]\+\s*//')"
}

fkill() {
	local pids
	# Show PID, USER, COMMAND; multi-select
	pids=$(ps -eo pid,user,comm --sort=pid | awk '{printf "%-8s %-15s %s\n",$1,$2,$3}' | fzf --bind 'esc:abort' --header="Select process(es) to kill" --multi | awk '{print $1}')

	if [[ -n "$pids" ]]; then
		# Use xargs to split lines properly
		echo "$pids" | xargs kill 2>/dev/null || echo "$pids" | xargs kill -9
		echo "Killed PID(s): $pids"
	else
		echo "No process selected."
	fi
}

# ======================================================================================
# UI / colors
# ======================================================================================
export FZF_DEFAULT_OPTS="--color=fg:#f8f8f2,hl:#f92672,fg+:#f8f8f2,hl+:#fd971f,pointer:#66d9ef,marker:#a6e22e,info:#ae81ff,prompt:#f8f8f2"
export EZA_COLORS="Makefile=38;5;197;1;4"

# ======================================================================================
# Atuin
# ======================================================================================
_cached_init atuin

# ======================================================================================
# Keybinds
# ======================================================================================
# Up/Down: search history by what's typed.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for km in emacs viins vicmd; do
	bindkey -M $km '^[[A' up-line-or-beginning-search
	bindkey -M $km '^[OA'  up-line-or-beginning-search
	bindkey -M $km '^[[B' down-line-or-beginning-search
	bindkey -M $km '^[OB'  down-line-or-beginning-search
	bindkey -M $km '^[[C' forward-char
	bindkey -M $km '^[OC' forward-char
	bindkey -M $km '^[[D' backward-char
	bindkey -M $km '^[OD' backward-char
done

# ======================================================================================
# Keep prompt anchored to the bottom of the terminal
# ======================================================================================
# Scrolls the screen content down so the prompt (and the history above it) lands on
# the last line, and moves the cursor with it so zle stays consistent.
# Two triggers: terminal resize (TRAPWINCH) and before each prompt (precmd), the
# latter for TUIs like claude/nvim that exit leaving the cursor high on the screen.
zmodload zsh/zselect
typeset -g _anchor_rows=$LINES
typeset -g _anchor_busy=0

# Query the cursor row (reply: ESC[row;colR) and scroll content+cursor down to
# the last line.
_anchor-scroll-to-bottom() {
	[[ $TERM == dumb ]] && return 0
	local _esc row col
	print -n '\e[6n' > /dev/tty
	IFS='[;' read -rs -t 1 -d R _esc row col < /dev/tty || return 0
	[[ $row == <-> ]] || return 0
	local pad=$(( LINES - row ))
	(( pad > 0 )) && printf '\e[%dT\e[%dB' $pad $pad > /dev/tty
}

_anchor-prompt-bottom() {
	local prev=$_anchor_rows
	_anchor_rows=$LINES

	{
		# Only when the terminal grew taller: on shrink kitty already keeps the
		# prompt at the bottom, and querying mid-rewrap during rapid window
		# spawning is what causes glitched prompt lines.
		(( LINES > prev )) || return 0
		(( _anchor_busy )) && return 0
		# Don't touch the screen while editing a multi-line command
		[[ $BUFFER == *$'\n'* ]] && return 0
		_anchor_busy=1

		_anchor-scroll-to-bottom
	} always {
		_anchor_busy=0
		# One clean repaint at the new size; also heals p10k rewrap artifacts
		zle reset-prompt 2>/dev/null
	}
}
zle -N _anchor-prompt-bottom

# Fires on every terminal resize (window opened/closed/tiled in Hyprland)
TRAPWINCH() {
	zle && zle _anchor-prompt-bottom 2>/dev/null
}

# Re-anchor before drawing each prompt (no-op when the cursor is already on the
# last line, i.e. after any normal full-width scroll of output).
_anchor-precmd() {
	# Skip if the user typed ahead: the cursor-report read would eat those keys
	zselect -t 0 -r 0 && return 0
	_anchor-scroll-to-bottom
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _anchor-precmd
