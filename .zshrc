# zsh options {{{
if [[ -f $HOME/.zsh-$(hostname)-pre ]]; then
  source $HOME/.zsh-$(hostname)-pre 
fi

ZSH_THEME="jcarson"
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

# keybinds {{{
# vi-mode fixes
# unbind ALL keys in viins mode and only bind jk to command mode
bindkey -rM viins "^["
bindkey -M viins 'jk' vi-cmd-mode

# don't use these bindings. get used to ctrl+a and ctrl+e
bindkey -r "${terminfo[khome]}" #beginning-of-line
bindkey -r "${terminfo[kend]}" #end-of-line
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

# print on shell start {{{
# use neofetch as a welcome message
neofetch
# }}}
