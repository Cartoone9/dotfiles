# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias g='git fetch --all --prune && git log --oneline --all --graph --decorate -n 50'
alias gs='git status'
alias ga='git add . && git status'
alias gc='git commit -m'
alias gp='git push'
alias gf='git fetch && git status'
alias gpu='git pull'
alias updt='brew update'
alias update='sudo apt update && sudo apt upgrade -y'
alias vi='nvim'
alias ccw='cc -Wall -Werror -Wextra'
alias norm='norminette'
alias bat='batcat'
alias cl='printf "\n%.0s" {1..$LINES}'
alias cls='cl && ls'
alias cll='cl && ll'
alias clt='cl && lt'
alias format='c_formatter_42 ./**/*.{c,h} > /dev/null && echo "Formatting done."'
# alias ls='eza --icons'
# alias ll='eza -l --icons'
# alias la='eza -la --icons'
# alias lt='eza --tree --icons'
# alias l='ll'
alias numpad='echo 0 | sudo tee /sys/class/leds/input4::numlock/brightness'
alias fd='fdfind'
alias ff='cl && fastfetch'
alias cfinit='printf -- "-std=c++98\n-Wall\n-Wextra\n-Werror\n-Ihdrs\n-Isrcs\n" > compile_flags.txt'
alias iginit='printf -- "*.o\n.objs\ncompile_flags.txt\n" >> .gitignore'
alias check='~/scripts/check_repos.zsh'

# --- EZA Wrapper Functions for Completion Fix (Revised) ---

unfunction ls 2>/dev/null
unalias ls 2>/dev/null
function ls() {
    # Call the actual eza binary with your desired flags
    command eza --icons "$@"
}
# Map the 'ls' function to use the '_eza' completion logic
# compdef _eza ls

unfunction ll 2>/dev/null
unalias ll 2>/dev/null
function ll() {
    command eza -l --icons "$@"
}
# compdef _eza ll

unfunction l 2>/dev/null
unalias l 2>/dev/null
function l() {
    ll "$@"
}
# compdef _eza l

unfunction lt 2>/dev/null
unalias lt 2>/dev/null
function lt() {
	command eza --tree --icons "$@"    
}
# compdef _eza lt

unfunction la 2>/dev/null
unalias la 2>/dev/null
function la() {
	command eza -la --icons "$@"    
}
# compdef _eza la
# ----------------------------------------------------

export PATH=/home/jramiro/.local/funcheck/host:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -f "$HOME/.profile" ]; then
	source "$HOME/.profile"
fi

# Function to change directory when exiting Neovim
# nvim() {
# 	command nvim "$@"
# 	if [ -f "$HOME/.nvim_last_dir" ]; then
# 		source "$HOME/.nvim_last_dir"
# 		rm "$HOME/.nvim_last_dir"
# 	fi
# }
#
# nvim() {
#     if declare -f node > /dev/null; then
#         zsh_nvm_lazy_load
#     fi
#
#     command nvim "$@"
# }

printf '\n%.0s' {1..$LINES}

# NVM ===================================================================================================
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NVM_DIR="$HOME/.nvm"

# Define the function that loads nvm only when needed
zsh_nvm_lazy_load() {
  # Cleanup the placeholder functions
  unset -f nvm node npm npx yarn pnpm 2>/dev/null

  # Load NVM
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  
  # Load NVM bash completion (optional, slightly slower)
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# Create placeholder functions that trigger the loader
nvm() { zsh_nvm_lazy_load; nvm "$@"; }
node() { zsh_nvm_lazy_load; node "$@"; }
npm() { zsh_nvm_lazy_load; npm "$@"; }
npx() { zsh_nvm_lazy_load; npx "$@"; }
yarn() { zsh_nvm_lazy_load; yarn "$@"; }
pnpm() { zsh_nvm_lazy_load; pnpm "$@"; }
# NVM ===================================================================================================

FD_EXCLUDES=(--exclude '.cache' --exclude '.mozilla' --exclude 'node_modules' --exclude '.git' --exclude '.cargo' --exclude '.var' --exclude '.local')
BASES=(. ~/42 ~/CTF ~/Documents ~/Downloads ~/Desktop)

# fzf powered main directories search
cdf() {
	local dir

	dir=$(fd "${BASES[@]}" \
		--type d \
		--hidden \
		--no-ignore \
		"${FD_EXCLUDES[@]}" \
		| sed "s|^$HOME|~|" \
		| fzf --preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
		--preview-window=right:50%:wrap)

	[ -n "$dir" ] && cd "${dir/#\~/$HOME}"
}

# fzf powered main directories search and vi
cdw() {
	local dir

	dir=$(fd "${BASES[@]}" \
		--type d \
		--hidden \
		--no-ignore \
		"${FD_EXCLUDES[@]}" \
		| sed "s|^$HOME|~|" \
		| fzf --preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
		--preview-window=right:50%:wrap)

	[ -n "$dir" ] && cd "${dir/#\~/$HOME}" && vi
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
		| fzf --preview 'eza --icons --group-directories-first --color=always --tree --level=2 "$(echo {} | sed "s|^~|$HOME|")"' \
		--preview-window=right:50%:wrap)

	# Convert back to full path for cd
	[ -n "$dir" ] && cd "${dir/#\~/$HOME}"
}

# fzf powered history search
fh() {
	eval "$(fc -l 1 | fzf --tac --no-sort +s --preview 'echo {}' | sed 's/^[0-9]\+\s*//')"
}

# fzf powered process killer
fkill() {
	local pids
	# Show PID, USER, COMMAND; multi-select
	pids=$(ps -eo pid,user,comm --sort=pid | awk '{printf "%-8s %-15s %s\n",$1,$2,$3}' | fzf --header="Select process(es) to kill" --multi | awk '{print $1}')

	if [[ -n "$pids" ]]; then
		# Use xargs to split lines properly
		echo "$pids" | xargs kill 2>/dev/null || echo "$pids" | xargs kill -9
		echo "Killed PID(s): $pids"
	else
		echo "No process selected."
	fi
}

# fzf colors
export FZF_DEFAULT_OPTS="--color=fg:#f8f8f2,hl:#f92672,fg+:#f8f8f2,hl+:#fd971f,pointer:#66d9ef,marker:#a6e22e,info:#ae81ff,prompt:#f8f8f2"

# eza theme color
export EZA_COLORS="Makefile=38;5;197;1;4"

# Go config
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin
