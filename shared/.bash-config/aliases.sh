alias conf_file_text="which figlet && figlet -w 100 -f /usr/share/figlet/fonts/big.flf"

# (c)hange (t)erminal (t)itle
alias ctt="__change_terminal_title__"

# (e)xtract (f)ile(n)ames
alias efn="awk -F ':' '{print \$1}' | sort | uniq"

which gem 1>/dev/null 2>/dev/null && alias gem_dir="cd $(gem environment | grep -e '- INSTALLATION DIRECTORY:' | sed 's/^.*: //g')"

alias genpass="__genpass__"

# REVIEW: Maybe I should have all the git aliases in their own file.

# (g)it (c)ommit (p)rogress
alias gcp="git add -A && git commit -m 'progress'"
# (g)it (f)irst (p)ush
alias gfp="__git_first_push__"
alias git_first_push="__git_first_push__"
alias git_prep_deploy="__git_prep_deploy__"
alias gpd="__git_prep_deploy__"
alias git_sync_master="__git_sync_master__"
alias gits="git status --short"
alias grep="grep --color=auto"
# (g)it (s)ync (m)aster
alias gsm="__git_sync_master__"
alias ls="ls --color=auto"
alias ruby_file_text="which figlet && figlet -w 100 -f /usr/share/figlet/fonts/standard.flf"
alias sbrc="source ~/.bashrc"
alias script_banner_text="which figlet 1>/dev/null 2>/dev/null && [[ -e "/usr/share/figlet/fonts/banner.flf" ]] && figlet -w 100 -f /usr/share/figlet/fonts/banner.flf"
alias systemd_top="top -p \$(ps aux | grep 'systemd' | grep -v "grep" | awk '{print \$2}' | paste -sd,)"
# (y)ou (t)ube (b)ack (g)round
alias ytbg="__ytbg__"

function __change_terminal_title__ {
  local name="$1"
  xdotool search --name jcarson set_window --name "$name"
}

function __genpass__ {
  local len="$1"
  cat /dev/urandom | tr -d -c 'A-Za-z0-9%*&' | fold -w $len | head -1
}

function __git_first_push__ {
  __echo_proc_step__ "pushing"
  git push --quiet --set-upstream origin $(git branch --show-current) 1>/dev/null 2>/dev/null
  ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)
}

function __git_sync_master__ {
  local local_target_branch=master
  local remote_target_branch=master
  local remote_git_remote=mtt

  git remote -v | grep -q "^${remote_git_remote}" && has_git_remote=1

  __echo_proc_step__ "changing to $local_target_branch branch"
  git checkout $local_target_branch --quiet
  ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)

  if [[ "$has_git_remote" == 1 ]]; then
    __echo_proc_step__ "fetching $remote_git_remote remote"
    git fetch $remote_git_remote --quiet
    ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)

    __echo_proc_step__ "merging ${remote_git_remote}/${remote_target_branch} into $local_target_branch"
    local merge_result=$(git merge --no-edit --no-ff ${remote_git_remote}/${remote_target_branch})
    ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)

    if [[ "$merge_result" != "Already up to date." ]]; then
      __echo_proc_step__ "pushing"
      git push --quiet
      ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)
    else
      __echo_info__ "$local_target_branch already up to date with ${remote_git_remote}/${remote_target_branch}"
    fi
  else
    __echo_proc_step__ "pulling"
    git pull --quiet
    ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)
  fi
}

# {{{ __git_prep_deploy__
function __git_prep_deploy__ {
  # NOTE: This is not comprehensive.

  local git_bin=$(which git)
  local remote_name=mtt
  local remote_stable_branch_name=stable
  local remote_master_branch_name=master
  local local_name=origin
  local local_stable_branch_name=stable
  local local_master_branch_name=master

  __echo_proc_step__ "checking if remote mtt exists"
  local mtt_remote_size=$($git_bin remote | grep "^${remote_name}" | wc -l)
  ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

  if [[ "$mtt_remote_size" == "1" ]]; then
    # We have an remote, so this remote is the main fork that we need to maintain.

    # REVIEW: Probably need to check if the remote has a stable.

    __echo_proc_step__ "fetching ${remote_name}/${remote_stable_branch_name} and ${remote_name}/${remote_master_branch_name}"
    $git_bin fetch -q ${remote_name} ${remote_stable_branch_name} ${remote_master_branch_name}
    ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

    __echo_proc_step__ "checking if ${local_name}/${local_stable_branch_name} exists"
    local local_stable_branch_size=$($git_bin branch | grep "${local_stable_branch_name}" | wc -l)
    ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

    # Make a local stable if we don't have one.
    if [[ "$local_stable_branch_size" == "0" ]]; then
      $git_bin checkout -q -b ${local_stable_branch_name}
      local_stable_branch_size=1
    fi

    if [[ "$local_stable_branch_size" == "1" ]]; then
      # We have a stable branch.

      __echo_proc_step__ "checking out ${local_name}/${local_stable_branch_name}"
      $git_bin checkout -q $local_stable_branch_name
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

      __echo_proc_step__ "pulling ${remote_name}/${remote_stable_branch_name}"
      $git_bin pull -q $remote_name $remote_stable_branch_name
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

      __echo_proc_step__ "merging ${remote_name}/${remote_master_branch_name}"
      $git_bin merge -q --no-edit --no-ff ${remote_name}/${remote_master_branch_name}
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

      __echo_proc_step__ "pushing ${remote_name}/${remote_stable_branch_name}"
      $git_bin push -q ${remote_name} ${remote_stable_branch_name}
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__
    else
      # We don't have a local stable branch!?
      :
    fi
  else
    # We don't have a remote, so this is assumed to be the main fork.

    if [[ $($git_bin branch --list $local_stable_branch_name | wc -l) == 0 ]]; then
      # This project doesn't have a stable branch, so we assume everything
      # is done off master and we don't need to merge master into stable.

      __echo_proc_step__ "checking out $local_master_branch_name"
      $git_bin checkout $local_master_branch_name --quiet
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

      __echo_proc_step__ "pulling"
      $git_bin pull --quiet
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__
    else
      # We have a stable, so we assume that we need to get master up to date
      # and get stable up to date and then merging master into stable.

      __echo_proc_step__ "checking out $local_master_branch_name"
      $git_bin checkout $local_master_branch_name --quiet
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

      __echo_proc_step__ "pulling"
      $git_bin pull --quiet
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

      __echo_proc_step__ "checking out $local_stable_branch_name"
      $git_bin checkout $local_stable_branch_name --quiet
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

      __echo_proc_step__ "pulling"
      $git_bin pull --quiet
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

      __echo_proc_step__ "merging $local_master_branch_name -> $local_stable_branch_name"
      $git_bin merge --no-edit --no-ff --quiet $local_master_branch_name
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

      __echo_proc_step__ "pushing $local_stable_branch_name"
      $git_bin push --quiet
      ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__
    fi
  fi
}
# }}}

function __ytbg__ {
  local input_ytid="$1"

  __echo_proc_step__ "checking for wget"
  which wget 1>/dev/null 2>/dev/null
  ([[ "$?" = "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)

  __echo_proc_step__ "checking for sqlite3"
  which sqlite3 1>/dev/null 2>/dev/null
  ([[ "$?" = "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)

  __echo_proc_step__ "checking for feh"
  which feh 1>/dev/null 2>/dev/null
  ([[ "$?" = "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)

  if [[ -z "$input_ytid" ]]; then
    __echo_proc_step__ "checking for mozilla db file"
    local firefox_db_file=$(find ~/.mozilla -type f -name 'places.sqlite')
    ([[ ! -z "$firefox_db_file" ]] && __echo_ok__) || (__echo_fail__ && return 1)

    echo -e "\033[0;35mCurrent Time\033[0;0m: $(date +"%Y-%m-%d %H:%M:%S"), \033[0;36mLast DB Update\033[0;0m: $(stat -c %y $firefox_db_file)"
    echo -n "Continue?(Y/n): "
    read user_answer

    [[ "$user_answer" != "Y" ]] && return 1

    __echo_proc_step__ "checking for latest YouTube IDs"
    local ytids="$(sqlite3 "file:$firefox_db_file?immutable=1" "SELECT moz_places.url FROM moz_places INNER JOIN moz_historyvisits ON moz_historyvisits.place_id=moz_places.id WHERE moz_places.url LIKE 'https://www.youtube.com/watch?v=%' ORDER BY moz_historyvisits.visit_date DESC LIMIT 50;" | sed 's/&.*//g' | sed 's/^.*=//g')"
    ([[ "$?" = "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)
  else
    local ytids=(${input_ytid})
  fi

  for ytid in $ytids; do
    [[ -z "$ytid" ]] && continue

    possible_thumbnails=(maxresdefault.jpg hqdefault.jpg mqdefault.jpg sddefault.jpg)
    for fname in "${possible_thumbnails[@]}"; do
      __echo_proc_step__ "downloading thumbnail(\033[0;35m${fname}\033[0;0m) for YouTube ID: \033[0;36m${ytid}\033[0;0m"
      cd ~/git_clones/wallpapers/youtube-tmp && wget -q https://img.youtube.com/vi/${ytid}/${fname} -O ~/git_clones/wallpapers/youtube-tmp/${ytid}.jpg
      if [[ "$?" = "0" ]]; then
        __echo_ok__
      else
        __echo_fail__
        continue
      fi

      feh --bg-fill --no-fehbg ~/git_clones/wallpapers/youtube-tmp/${ytid}.jpg
      if [[ -z "$input_ytid" ]]; then
        echo -n "This Wallpaper?(Y/n): "
        read user_answer
      else
        user_answer=Y
      fi

      [[ "$user_answer" = "Y" ]] && return 0
      break
    done
  done

  return 0
}

alias list_colors="__list_colors__"
function __list_colors__ {
  for color_code in $(seq 0 255); do
    echo -e "${color_code} \033[38;5;${color_code}mamakakeru ryu no hirameki\033[0;0m"
  done
}
