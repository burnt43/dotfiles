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
alias conf_file_text="which figlet && figlet -w 100 -f /usr/share/figlet/fonts/big.flf"
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

bindkey "^[w" forward-word
bindkey "^[d^[w" kill-word
bindkey "^[b" backward-word
bindkey "^[d^[b" backward-kill-word

bindkey "^[d^[d" kill-whole-line
bindkey "^[h" beginning-of-line
bindkey "^[l" end-of-line

bindkey "^L" clear-screen
# }}}
# print on shell start {{{
# use neofetch as a welcome message
neofetch
# }}}
