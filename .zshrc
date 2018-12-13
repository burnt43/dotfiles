# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/jcarson/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="jcarson"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

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
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  vi-mode
)

# vi-mode fixes
# unbind ALL keys in viins mode and only bind jj to command mode
bindkey -rM viins "^["
bindkey -M viins 'jj' vi-cmd-mode

# don't use these bindings. get used to ctrl+a and ctrl+e
bindkey -r "${terminfo[khome]}" #beginning-of-line
bindkey -r "${terminfo[kend]}" #end-of-line

export LANG=en_US.UTF-8
export EDITOR='vim'
export PATH=$PATH:/usr/local/ruby/ruby-2.5.3/bin:~/scripts/scripts_in_path

alias msu1tracks_dev="cd /home/jcarson/git_clones/msu1tracks"

alias vpn="sudo openvpn --config /home/jcarson/vpn/vpn2-UDP4-1200-jcarson-config.ovpn"
alias work_machine="ssh 200.255.100.116"

alias mount_sd="udisksctl mount -b /dev/sdc1"
alias umount_sd="udisksctl unmount -b /dev/sdc1"

alias alttpr_cd="cd /run/media/jcarson/3765-3634/roms/0006_added_by_jim/randomizers/a_link_to_the_past"
alias alttpr_clean="alttpr_cd && find ./ -name 'alttp_msu.sfc' -exec rm {} \;"
alias alttpr_mv_download_to_on_deck="alttpr_cd && mv /home/jcarson/Downloads/*.sfc ./on_deck_seeds"
alias alttpr_mv_on_deck_to_wip='alttpr_cd && [ "$(ls ./wip_seeds | wc -l)" -eq "0" ] && mv "$(ls -t ./on_deck_seeds/* | head -1)" ./wip_seeds'
alias alttpr_mv_wip_to_completed='alttpr_cd && [ "$(ls ./wip_seeds | wc -l)" -eq "1" ] && mv "$(ls -t ./wip_seeds/* | head -1)" ./completed_seeds'

alias keyboard_rate="xset -display :0 r rate 350 50"

source $ZSH/oh-my-zsh.sh

# DO NOT SHARE HISTORY!
unsetopt share_history

# use neofetch as a welcome message
neofetch

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
