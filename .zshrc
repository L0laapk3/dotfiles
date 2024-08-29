#! /bin/env zsh

ZLE_RPROMPT_INDENT=0

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Keybinds
WORDCHARS=\=\\\|$WORDCHARS:s:/: # Add.=\| remove / from word chars. Todo: remove .

bindkey "^[[3~"   delete-char        # delete key
bindkey "^[[H"    beginning-of-line  # home
bindkey "^[[F"    end-of-line        # end
bindkey "^[[1;5C" forward-word       # ctrl arrows
bindkey "^[[1;5D" backward-word
bindkey "^H"      backward-kill-word # ctrl backspace
bindkey "^[[3;5~" kill-word          # ctrl delete

zstyle ':completion:*' group-order \
    aliases suffix-aliases functions reserved-words builtins commands \
    remotes hosts recent-branches commits \
    all-expansions expansions options


# Turn on history file
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history # For multiple parallel sessions


# autocd
setopt autocd


### Install zinit
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
	print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
	command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
	command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
		print -P "%F{33} %F{34}Installation successful.%f%b" || \
		print -P "%F{160} The clone has failed.%f%b"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"


### Plugins

# These plugins cannot be loaded in turbo mode for some reason
_zinit_plugins=(
	atload="source ~/.p10k.zsh"
		romkatv/powerlevel10k

	atload="                                             \
		bindkey -M menuselect                            \
			'^[[D'    .backward-char                     \
			'^[[C'    .forward-char                      \
			'^[[1;5C' .forward-word                      \
			'^[[1;5D' .backward-word                     \
			'^I'      menu-complete                      \
			'^[[Z'    reverse-menu-complete              \
			'^M'      .accept-line;                      \
		bindkey                                          \
			'^I'   menu-select                           \
			'^[[Z' menu-select;                          \
		zstyle ':completion:*:paths' path-completion yes \
	"
		marlonrichert/zsh-autocomplete
)
_zinit_late_plugins=(
	OMZP::git

	atinit="ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
		zdharma-continuum/fast-syntax-highlighting

	blockf
		zsh-users/zsh-completions

	atload="!_zsh_autosuggest_start"
		zsh-users/zsh-autosuggestions

	atload="ZSHZ_CASE=smart; ZSHZ_NO_RESOLVE_SYMLINKS=1; ZSHZ_UNCOMMON=1"
		agkozak/zsh-z
)

zinit      lucid light-mode depth=1 for ${_zinit_plugins[@]}
zinit wait lucid light-mode depth=1 for ${_zinit_late_plugins[@]}



# aliases
alias ll="ls -la"
alias llt="ll -rt"
alias du="du -ahd1 | sort -h"

alias nice="nice -n19 ionice -c3" # More nice :)

alias pkill="pkill -u $USER"

alias "sudo apt install"="sudo apt install -y"
