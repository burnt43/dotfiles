# vi-mode
MODE_INDICATOR="%{$bg[red]%}vi-mode%{$reset_color%}"

# left prompt
local exit_status="%(?.%{$fg[green]%}■.%{$fg[red]%}■)%{$reset_color%}"
local user_name="%n"
local host_name="%{$fg_bold[red]%}%m%{$reset_color%}"
PROMPT='┌${exit_status} ${user_name}@${host_name} %c
└%% '

# right prompt
#RPROMPT="test"
