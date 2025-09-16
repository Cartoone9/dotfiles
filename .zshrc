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
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

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
alias cls='printf "\n%.0s" {1..$LINES} && ls'
alias clt='printf "\n%.0s" {1..$LINES} && lt'
alias format='c_formatter_42 ./**/*.{c,h} > /dev/null && echo "Formatting done."'
alias lock='/sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock /home/jramiro/Pictures/lock-gto.gif center center 40% 40%'
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias lt='eza --tree'
alias numpad='echo 0 | sudo tee /sys/class/leds/input4::numlock/brightness'
alias fd='fdfind'

alias franciPC=/home/cartoone/francinette/tester.sh
alias franci42=/home/jramiro/francinette/tester.sh
alias franciMBP=/Users/joris/francinette/tester.sh

export PATH=/home/jramiro/.local/funcheck/host:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -f "$HOME/.profile" ]; then
	source "$HOME/.profile"
fi

# Function to change directory when exiting Neovim
nvim() {
	command nvim "$@"
	if [ -f "$HOME/.nvim_last_dir" ]; then
		source "$HOME/.nvim_last_dir"
		rm "$HOME/.nvim_last_dir"
	fi
}

printf '\n%.0s' {1..$LINES}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fuzzy finder cd
cdf() {
	local dir
	local bases=(~/42 ~/CTF ~/Documents ~/Downloads ~/Desktop ~/.config)

	dir=$(fd . . "${bases[@]}" \
		--type d \
		--hidden \
		--no-ignore \
		--exclude '.cache' \
		--exclude '.local' \
		--exclude '.mozilla' \
		--exclude 'node_modules' \
		--exclude '.git' \
		--exclude '.cargo' \
		--exclude '.var' \
		| sed "s|^$HOME|~|" \
		| fzf --preview 'ls -la "$(echo {} | sed "s|^~|$HOME|")"')

	[ -n "$dir" ] && cd "${dir/#\~/$HOME}"
}

cdfa() {
	local dir
	local bases=(~)

	dir=$(fd . "${bases[@]}" \
		--type d \
		--hidden \
		--no-ignore \
		--exclude '.cache' \
		--exclude '.mozilla' \
		--exclude 'node_modules' \
		--exclude '.git' \
		--exclude '.cargo' \
		--exclude '.var' \
		| sed "s|^$HOME|~|" \
		| fzf --preview 'ls -la "$(echo {} | sed "s|^~|$HOME|")"')

		# Convert back to full path for cd
		[ -n "$dir" ] && cd "${dir/#\~/$HOME}"
	}

export FZF_DEFAULT_OPTS="--color=fg:#f8f8f2,hl:#f92672,fg+:#f8f8f2,hl+:#fd971f,pointer:#66d9ef,marker:#a6e22e,info:#ae81ff,prompt:#f8f8f2"
