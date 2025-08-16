function __shell_last_command__ {
  if [[ "$?" == "0" ]]; then
    echo -ne "\033[0;32m■\033[0;0m"
  else
    echo -ne "\033[0;31m■\033[0;0m"
  fi
}

function __shell_basic_info__ {
  if [[ "$(pwd)" == "/home/$(whoami)" ]]; then
    effective_dir="~"
  else
    effective_dir="$(basename $(pwd))"
  fi

  echo -ne "$(whoami)@\033[1;32m$(hostname)\033[0;0m \033[0;34m$effective_dir\033[0;0m"
}

function __shell_git_plugin__ {
  local my_dir=$(pwd)
  local in_git_repo=0

  while [[ "$my_dir" != "/" ]]; do
    [[ -e "$my_dir/.git" ]] && in_git_repo=1 && break

    my_dir="$(dirname $my_dir)"
  done

  [[ "$in_git_repo" == "0" ]] && return

  local branch=$(git branch --show-current)

  local files="$(git status --porcelain | wc -l | sed -E 's/^[[:space:]]+//g')"
  local files_changed_and_committed="$(git status --porcelain | grep -P '^M[^M]' | wc -l | sed -E 's/^[[:space:]]+//g')"
  local files_changed_and_not_committed="$(git status --porcelain | grep -P "^(.M|\?)" | wc -l | sed -E 's/^[[:space:]]+//g')"

  if [[ "$files_changed_and_committed" != "0" && "$files_changed_and_committed" == "$files" ]]; then
    # all changes ready to be committed
    echo -ne "(\033[0;33m$branch\033[0;0m"
  elif [[ "$files_changed_and_not_committed" == "0" ]]; then
    # clean
    echo -ne "(\033[0;36m$branch\033[0;0m"
  else
    # dirty
    echo -ne "(\033[0;31m$branch\033[0;0m"
  fi

  local find_gem_result=$(find ${my_dir} -maxdepth 1 -name '*.gem' | head -1)

  if [[ ! -z "$find_gem_result" ]]; then
    local gem_version=$(basename $find_gem_result | sed 's/^.*-//g' | sed 's/\.gem//g')
    echo -n "/${gem_version})"
  else
    echo -n ")"
  fi
}

my_hostname="$(hostname)"
case "$my_hostname" in
  fakebiz42069*)
    PS1=' ┌$(__shell_last_command__) $(__shell_basic_info__)$(__shell_git_plugin__)\n ┴% '
    ;;
  *)
    PS1=' ┌$(__shell_last_command__) $(__shell_basic_info__)$(__shell_git_plugin__)\n┴% '
    ;;
esac
