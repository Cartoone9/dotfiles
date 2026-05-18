# Clear screen by printing empty lines
printf '\n%.0s' {1..$LINES}

# ======================================================================================
# PATH
# ======================================================================================
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.local/funcheck/host:$PATH"
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
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi

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
alias updt='brew update'
alias update='topgrade && echo && check'
alias vi='nvim'
alias ccw='cc -Wall -Werror -Wextra'
alias norm='norminette'
alias bat='batcat'
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
# NVM (lazy load)
# ======================================================================================
export NVM_DIR="$HOME/.nvm"

zsh_nvm_lazy_load() {
	# Cleanup the placeholder functions
	unset -f nvm node npm npx yarn pnpm 2>/dev/null

	# Load NVM
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

	# Load NVM bash completion (optional, slightly slower)
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# Create placeholder functions that trigger the loader
nvm()  { zsh_nvm_lazy_load; nvm "$@"; }
node() { zsh_nvm_lazy_load; node "$@"; }
npm()  { zsh_nvm_lazy_load; npm "$@"; }
npx()  { zsh_nvm_lazy_load; npx "$@"; }
yarn() { zsh_nvm_lazy_load; yarn "$@"; }
pnpm() { zsh_nvm_lazy_load; pnpm "$@"; }

# ======================================================================================
# Zoxide
# ======================================================================================
[[ -f "$HOME/dotfiles/.zoxide.zsh" ]] && source "$HOME/dotfiles/.zoxide.zsh"

# ======================================================================================
# fd/fzf directory helpers
# ======================================================================================
FD_EXCLUDES=(
	--exclude '.cache'
	--exclude '.mozilla'
	--exclude 'node_modules'
	--exclude '.git'
	--exclude '.cargo'
	--exclude '.var'
	--exclude '.local'
	--exclude '.npm'
	--exclude '.pnpm-store'
	--exclude 'pkg/mod'
)

# All non-hidden directories directly under $HOME
setopt EXTENDED_GLOB

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

cdf() {
	local dir
	dir=$(
		{
			# 1) include the base directories themselves
			print -rl -- "${BASES[@]}"

			# 2) include their subdirectories
			fd --type d --hidden --no-ignore "${FD_EXCLUDES[@]}" . "${BASES[@]}"
		} \
			| sed "s|^$HOME|~|" \
			| sort -u \
			| fzf --bind 'esc:abort' \
			--preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
			--preview-window=right:50%:wrap
		)
	[[ -n "$dir" ]] && cd "${dir/#\~/$HOME}"
}

cdw() {
	local dir
	dir=$(
		fd --type d --hidden --no-ignore "${FD_EXCLUDES[@]}" . "${BASES[@]}" \
			| sed "s|^$HOME|~|" \
			| fzf --bind 'esc:abort' \
			--preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
			--preview-window=right:50%:wrap
		)
	[[ -n "$dir" ]] && cd "${dir/#\~/$HOME}" && vi
}

# fzf powered all directories search
cdfa() {
	local dir

	dir=$(fd . ~ \
		--type d \
		--hidden \
		--no-ignore \
		"${FD_EXCLUDES[@]}" \
		| sed "s|^$HOME|~|" \
		| fzf --bind 'esc:abort' \
		--preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
		--preview-window=right:50%:wrap)

	# Convert back to full path for cd
	[ -n "$dir" ] && cd "${dir/#\~/$HOME}"
}

# zoxide-ranked directory picker
cdd() {
	local dir
	local query="${*:-}"

	dir=$(
		zoxide query -l 2>/dev/null \
			| sed "s|^$HOME|~|" \
			| sort -u \
			| fzf --bind 'esc:abort' \
				--no-sort \
				--query "$query" \
				--preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
				--preview-window=right:50%:wrap
	)

	[[ -n "$dir" ]] && cd "${dir/#\~/$HOME}"
}

# ======================================================================================
# fd/fzf directory helpers
# ======================================================================================

# Shared appearance for cdf/cdw/cdfa/cdd
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

# Candidates for normal directory search
_cdf_candidates() {
	{
		print -rl -- "${BASES[@]}"
		fd --type d --hidden --no-ignore "${FD_EXCLUDES[@]}" . "${BASES[@]}" 2>/dev/null
	} | _cdf_clean_paths
}

# Search useful/project directories from BASES
cdf() {
	local dir
	dir=$(
		{
			# 1) include the base directories themselves
			print -rl -- "${BASES[@]}"

			# 2) include their subdirectories
			fd --type d --hidden --no-ignore "${FD_EXCLUDES[@]}" . "${BASES[@]}"
		} \
			| sed "s|^$HOME|~|" \
			| sort -u \
			| fzf "${DIR_FZF_OPTS[@]}" \
				--border-label=cdf \
				--bind 'esc:abort' \
				--preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
				--preview-window=right:50%:wrap
	)

	[[ -n "$dir" ]] && cd "${dir/#\~/$HOME}"
}

# Search useful/project directories from BASES, then open nvim
cdw() {
	local dir
	dir=$(
		fd --type d --hidden --no-ignore "${FD_EXCLUDES[@]}" . "${BASES[@]}" \
			| sed "s|^$HOME|~|" \
			| fzf "${DIR_FZF_OPTS[@]}" \
				--border-label=cdw \
				--bind 'esc:abort' \
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
			| sort -u \
			| fzf "${DIR_FZF_OPTS[@]}" \
				--border-label=cdd \
				--no-sort \
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
eval "$(atuin init zsh)"

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
