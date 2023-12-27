function __arch_pkg_last_system_upgrade__ {
  local threshold="$1"

  [[ -z "$threshold" ]] && threshold=10

  pacman --query --info \
  | grep '^Install Date' \
  | awk '{
    if($6 == "Jan"){
      month_num="01"
    }
    else if($6 == "Feb"){
      month_num="02"
    }
    else if($6 == "Mar"){
      month_num="03"
    }
    else if($6 == "Apr"){
      month_num="04"
    }
    else if($6 == "May"){
      month_num="05"
    }
    else if($6 == "Jun"){
      month_num="06"
    }
    else if($6 == "Jul"){
      month_num="07"
    }
    else if($6 == "Aug"){
      month_num="08"
    }
    else if($6 == "Sep"){
      month_num="09"
    }
    else if($6 == "Oct"){
      month_num="10"
    }
    else if($6 == "Nov"){
      month_num="11"
    }
    else if($6 == "Dec"){
      month_num="12"
    }
    printf("%s-%s-%s\n", $7, month_num, $5);
  }' \
  | sort -n -r \
  | uniq -c \
  | awk "{
    threshold=$threshold;
    count=\$1;
    date=\$2;
    if(count >= threshold){
      print \$2;
      exit(0);
    }
  }"
}

function __arch_pkg_search__ {
  local package_name="$1"

  pacman -Ss $package_name
}

function __arch_pkg_install__ {
  local package_name="$1"

  sudo pacman -S $package_name
}

function __arch_pkg_search__ {
  pacman -Q
}

function __arch_pkg_remove__ {
  local package_name="$1"

  sudo pacman -Rs $package_name
}

alias pkg-search="__arch_pkg_search__"
alias pkg-install="__arch_pkg_install__"
alias pkg-list="__arch_pkg_search__"
alias pkg-remove="__arch_pkg_remove__"
alias pkg-last-system-upgrade="__arch_pkg_last_system_upgrade__ 10"
