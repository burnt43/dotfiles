function __echo_error__ {
  local msg="$1"

  echo -e "[\033[0;31mERROR\033[0;0m] - $msg"
}

function __echo_proc_step__ {
  local msg="$1"

  echo -e -n "$msg..."
}

function __echo_fail__ {
  echo -e "\033[0;31mFAIL\033[0;0m"
}

function __echo_ok__ {
  echo -e "\033[0;32mOK\033[0;0m"
}

function __echo_info__ {
  local msg="$1"

  echo -e "[\033[0;34mINFO\033[0;0m] - $msg"
}

function __cap_deploy__ {
  local release_user="$1"
  shift
  local release_dir="$1"
  shift
  local my_env="$1"
  shift

  local src_branch=master
  local dst_branch=stable

  [[ $(sudo su $release_user -c "cd $release_dir && git branch --list $dst_branch" | wc -l) == 1 ]] && has_dst_branch=1

  # get master up to date.
  __echo_proc_step__ "ensuring $src_branch is up to date"
  sudo su $release_user -c "cd $release_dir && git checkout $src_branch --quiet && git pull --quiet"
  ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)

  if [[ "$has_dst_branch" == "1" ]]; then
    # get stable up to date.
    __echo_proc_step__ "ensuring $dst_branch is up to date"
    sudo su $release_user -c "cd $release_dir && git checkout $dst_branch --quiet && git pull --quiet"
    ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)

    # merge master into stable.
    __echo_proc_step__ "merge $src_branch into $dst_branch"
    merge_result=$(sudo su $release_user -c "cd $release_dir && git merge --no-edit --no-ff $src_branch")
    ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)

    if [[ "$merge_result" != "Already up to date." ]]; then
      # commit the merge and push.
      __echo_proc_step__ "pushing"
      sudo su $release_user -c "cd $release_dir && git push --quiet"
      ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)
    else
      __echo_info__ "$dst_branch already up to date with $src_branch"
    fi
  fi

  # make sure we have the latest gems or else running bundle exec ... will complain.
  __echo_proc_step__ "install gems"
  sudo su $release_user -c "cd $release_dir && bundle install --quiet 2>/dev/null"
  ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)

  # do the deploy!
  sudo su $release_user -c "cd $release_dir && bundle exec cap $my_env deploy $*"
}
