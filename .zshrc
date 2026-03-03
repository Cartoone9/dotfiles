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
alias check='~/scripts/check_repos.zsh'
alias ssh='kitten ssh'
alias diff='kitten diff'
alias lg="lazygit"

# ======================================================================================
# eza wrapper functions (replace ls/ll/lt/etc)
# ======================================================================================
unfunction ls 2>/dev/null
unalias ls 2>/dev/null
function ls() {
	command eza --icons "$@"
}

unfunction ll 2>/dev/null
unalias ll 2>/dev/null
function ll() {
	command eza -l --icons "$@"
}

unfunction l 2>/dev/null
unalias l 2>/dev/null
function l() {
	ll "$@"
}

unfunction lt 2>/dev/null
unalias lt 2>/dev/null
function lt() {
	command eza --tree --icons "$@"
}

unfunction la 2>/dev/null
unalias la 2>/dev/null
function la() {
	command eza -la --icons "$@"
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
# fd/fzf directory helpers
# ======================================================================================
FD_EXCLUDES=(--exclude '.cache' --exclude '.mozilla' --exclude 'node_modules' --exclude '.git' --exclude '.cargo' --exclude '.var' --exclude '.local')
# All non-hidden directories directly under $HOME
BASES=(
  $HOME/*(/N:^Music:^Pictures:^Videos)
  $HOME/.config(/N)
)

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
# Up/Down: search history by what's typed; when you reach the newest match,
# one extra Down clears to an empty prompt.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search

typeset -g __HS_ACTIVE=0

_hs_up() {
	zle up-line-or-beginning-search
	(( $? == 0 )) && __HS_ACTIVE=1
}

_hs_down() {
	if (( __HS_ACTIVE )); then
		zle down-line-or-beginning-search
		if (( $? != 0 )); then
			__HS_ACTIVE=0
			BUFFER=""
			CURSOR=0
		fi
	else
		# normal behavior when not in a search-navigation session
		zle down-line-or-history
	fi
}

zle -N _hs_up
zle -N _hs_down

for km in emacs viins vicmd; do
	bindkey -M $km '^[[A' _hs_up
	bindkey -M $km '^[OA'  _hs_up
	bindkey -M $km '^[[B' _hs_down
	bindkey -M $km '^[OB'  _hs_down
	bindkey -M $km '^[[C' forward-char
	bindkey -M $km '^[OC' forward-char
	bindkey -M $km '^[[D' backward-char
	bindkey -M $km '^[OD' backward-char
done
