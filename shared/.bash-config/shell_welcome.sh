function __print_md__ {
  [[ ! -e /proc/mdstat ]] && return 0

  which mdadm 1>/dev/null 2>/dev/null
  if [[ "$?" == "0" ]]; then
    for md_device in $(cat /proc/mdstat | grep '^md' | awk '{print $1}'); do
      # NOTE: mdadm needs to run as super-user. For each md device, you will
      #   need to put that in sudoers or sudoers.d to have these commands
      #   be run without a password.
      local state="$(sudo /usr/bin/mdadm --detail -v /dev/$md_device | grep -E '^\s+State' | awk '{print $3}')"

      if [[ "$state" != "clean" && "$state" != "active" ]]; then
        echo -e "[\033[0;31mNOTICE\033[0;0m] - $md_device state: $state"
      fi
    done
  fi
}

function __print_fetch__ {
  which neofetch 1>/dev/null 2>/dev/null && neofetch
}

__print_md__
