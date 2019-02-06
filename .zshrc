#          _              
#         | |             
#  _______| |__  _ __ ___ 
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__ 
# /___|___/_| |_|_|  \___|
#
# zsh options {{{
if [[ -f $HOME/.zsh-$(hostname)-pre ]]; then
  source $HOME/.zsh-$(hostname)-pre 
fi

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
ZSH_CUSTOM=~/.oh-my-zsh/custom
# }}}
# plugins {{{
plugins=(
  git
  vi-mode
)
# }}}
# source local config {{{
if [[ -f $HOME/.zsh-$(hostname) ]]; then
  source $HOME/.zsh-$(hostname)
fi
# }}}
# exports {{{
export LANG=en_US.UTF-8
export EDITOR='vim'
export XDG_CONFIG_HOME=$HOME/.config
# }}}
# aliases {{{
alias grep="grep --color=auto"
alias awk_filenames_from_grep="awk -F ':' '{print $1}' | sort | uniq"
alias gem_dir="cd $(gem environment | grep -e '- INSTALLATION DIRECTORY:' | sed 's/^.*: //g')"
# }}}
# cache and source {{{
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh
# }}}
# unsets {{{
unsetopt share_history
# }}}
# keybinds {{{
# vi-mode fixes
# unbind ALL keys in viins mode and only bind jk to command mode
bindkey -rM viins "^["
bindkey -M viins 'jk' vi-cmd-mode

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

bindkey "^W" forward-word
bindkey "^D^W" kill-word
bindkey "^B" backward-word
bindkey "^D^B" backward-kill-word

bindkey "^D^D" kill-whole-line
bindkey "^H" beginning-of-line
bindkey "^L" end-of-line

bindkey "^[l" clear-screen
# }}}
# print on shell start {{{
# use neofetch as a welcome message
neofetch
# }}}
