requiredver="5.5.0"
if [[ "$(echo "$requiredver\n$ZSH_VERSION" | sort -V | head -n1)" != "$requiredver" ]]; then
	return
fi;



ZLE_RPROMPT_INDENT=0

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Keybinds
WORDCHARS=$WORDCHARS:s:/: # Remove the / from word chars

bindkey "^[[3~"   delete-char        # delete key
bindkey "^[[H"    beginning-of-line  # home
bindkey "^[[F"    end-of-line        # end
bindkey "^[[1;5C" forward-word       # ctrl arrows
bindkey "^[[1;5D" backward-word
bindkey "^H"      backward-kill-word # ctrl backspace
bindkey "^[[3;5~" kill-word          # ctrl delete



# Turn on history file
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory



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

	atload="                                      \
		zstyle ':autocomplete:*:*' list-lines 99; \
		bindkey -M menuselect                     \
			'^[[D' .backward-char                 \
			'^[[C' .forward-char                  \
			'^[[1;5C' .forward-word               \
			'^[[1;5D' .backward-word;             \
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

	atload="ZSHZ_CASE=smart"
		agkozak/zsh-z
)

zinit      lucid light-mode depth=1 for ${_zinit_plugins[@]}
zinit wait lucid light-mode depth=1 for ${_zinit_late_plugins[@]}


# aliases
alias ll="ls -la"
alias llt="ll -rt"

alias nice="nice -n19 ionice -c3" # More nice :)

alias "sudo apt install"="sudo apt install -y"