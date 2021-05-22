CURRENT_BG='NONE'

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0'
}

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

prompt_dir() {
  prompt_segment magenta black '%c'
}

prompt_status() {
  if [[ "$?" -eq "0" ]]; then
    prompt_segment green black '%?'
  else
    prompt_segment red black '%?'
  fi
}

prompt_user_and_host() {
  prompt_segment black white '%n@%m'
}

## Main prompt
build_prompt() {
  prompt_status
  prompt_user_and_host
  prompt_dir
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
