# vi-mode
MODE_INDICATOR="%{$bg[red]%}vi-mode%{$reset_color%}"

# git
ZSH_THEME_GIT_PROMPT_PREFIX="git:%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$reset_color%}%{$fg[red]%}●"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$reset_color%}%{$fg[green]%}●"

# left prompt
local exit_status="%(?.%{$fg[green]%}■.%{$fg[red]%}■)%{$reset_color%}"
local user_name="%n"
local host_name="%{$fg_bold[green]%}%m%{$reset_color%}"
PROMPT='┌${exit_status} ${user_name}@${host_name} %c $(git_prompt_info)
└%% '

# right prompt
#RPROMPT="test"
