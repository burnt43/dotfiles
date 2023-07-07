#  _               _              
# | |             | |             
# | |__   __ _ ___| |__  _ __ ___ 
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__ 
# |_.__/ \__,_|___/_| |_|_|  \___|
#

# {{{ Shell Prefix
# {{{ function __shell_last_command__ 
function __shell_last_command__ {
  if [[ "$?" == "0" ]]; then
    echo -ne "\033[0;32m■\033[0;0m"
  else
    echo -ne "\033[0;31m■\033[0;0m"
  fi
}
# }}}
# {{{ function __shell_basic_info__ 
function __shell_basic_info__ {
  if [[ "$(pwd)" == "/home/$(whoami)" ]]; then
    effective_dir="~"
  else
    effective_dir="$(basename $(pwd))"
  fi

  echo -ne "$(whoami)@\033[1;32m$(hostname)\033[0;0m \033[0;34m$effective_dir\033[0;0m"
}
# }}}
# {{{ function __shell_git_plugin__ 
function __shell_git_plugin__ {
  local my_dir=$(pwd)
  local in_git_repo=0

  while [[ "$my_dir" != "/" ]]; do
    [[ -e "$my_dir/.git" ]] && in_git_repo=1 && break

    my_dir="$(dirname $my_dir)"
  done

  [[ "$in_git_repo" == "0" ]] && return

  if [[ "$(git status --porcelain | grep -P "^( M|\?)" | wc -l | sed -E 's/^[[:space:]]+//g')" == "0" ]]; then
    local changes_present="0"
  else
    local changes_present="1"
  fi

  local branch=$(git branch --show-current)

  if [[ "$changes_present" == "0" ]]; then
    echo -ne "(\033[0;36m$branch\033[0;0m)"
  else
    echo -ne "(\033[0;31m$branch\033[0;0m)"
  fi
}
# }}}
PS1=' ┌$(__shell_last_command__) $(__shell_basic_info__)$(__shell_git_plugin__)\n┴% '
# }}}
# {{{ Shell Input
# Use bind -P to list everything that is and isn't bound.

# remove default 'accept-line' binding
bind -r "\C-j"

# use vi mode
set -o vi

# remove default vi-movement-mode binding
bind -r "\e"

# set ctrl+j to vi-movement-mode
bind "\C-j":vi-movement-mode

# set ctrl+a to beginning-of-line
bind "\C-a":beginning-of-line
# set ctrl+e to end-of-line
bind "\C-e":end-of-line

bind "\C-l":clear-display
#}}}
# {{{ Distro
distro_name=$(uname -r | awk -F '-' '{print $2}')

case "$distro_name" in
# {{{ Distro.Centos
centos)
  function __centos_pkg_install__ {
    local pkg_name="$1"
    sudo dnf install $pkg_name
  }
  function __centos_pkg_list__ {
    local pkg_name="$1"
    dnf list installed $pkg_name
  }
  function __centos_pkg_remove__ {
    local pkg_name="$1"
    sudo dnf remove $pkg_name
  }

  alias pkg-install="__centos_pkg_install__"
  alias pkg-list="__centos_pkg_list__"
  alias pkg-remove="__centos_pkg_remove__"
  ;;
# }}}
# {{{ Distro.Gentoo
gentoo)
  function __gentoo_yes_no_prompt__ {
    echo -en "[\033[0;31mINPUT REQUIRED\033[0;0m] - $1 (Y/n): "
    read yes_no_choice

    if [[ "$yes_no_choice" == "Y" ]]; then
      return 0
    else
      return 1
    fi
  }

  function __gentoo_pkg_install__ {
    local pkg_name="$1"
    sudo emerge --ask $pkg_name
  }
  function __gentoo_pkg_list__ {
    local pkg_name="$1"
    qlist -IRv $pkg_name
  }
  function __gentoo_pkg_remove__ {
    local pkg_name="$1"
    sudo emerge --deselect $pkg_name
    sudo emerge --depclean -vp

    __gentoo_yes_no_prompt__ "continue with emerge --depclean -v?" 
    local rval="$?"
    if [[ "$rval" == "0" ]]; then
      sudo emerge --depclean -v
    fi
  }

  alias pkg-install="__gentoo_pkg_install__"
  alias pkg-list="__gentoo_pkg_list__"
  alias pkg-remove="__gentoo_pkg_remove__"
  ;;
# }}}
# {{{ Distro.Arch
arch*)
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

  # TODO: Define these aliases

  alias pkg-search="__arch_pkg_search__"
  alias pkg-install="__arch_pkg_install__"
  alias pkg-list="__arch_pkg_search__"
  alias pkg-remove="__arch_pkg_remove__"
  alias pkg-last-system-upgrade="__arch_pkg_last_system_upgrade__ 10"
  ;;
# }}}
esac
# }}}
# {{{ Functions
# {{{ __echo_error__
function __echo_error__ {
  local msg="$1"

  echo -e "[\033[0;31mERROR\033[0;0m] - $msg"
}
# }}}
# {{{ __echo_proc_step__
function __echo_proc_step__ {
  local msg="$1"

  echo -n "$msg..."
}
# }}}
# {{{ __echo_fail__
function __echo_fail__ {
  echo -e "\033[0;31mFAIL\033[0;0m"
}
# }}}
# {{{ __echo_ok__
function __echo_ok__ {
  echo -e "\033[0;32mOK\033[0;0m"
}
# }}}
# {{{ function __echo_info__ 
function __echo_info__ {
  local msg="$1"

  echo -e "[\033[0;34mINFO\033[0;0m] - $msg"
}
# }}}
# {{{ __cap_deploy__
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
# }}}
# }}}
# {{{ Aliases
case "$(hostname)" in
  # {{{ Aliases.burnt43
  burnt43)
    # {{{ Development Software Run/Test Helpers
    # {{{ ruby
    alias ruby2='source $(rubyv -v 2.6.10)'
    alias ruby3='source $(rubyv -v 3.1.1)'
    # }}}
    # {{{ agi_server
    alias agi_server_dev="ruby2 && cd ~/git_clones/agi-server"
    alias agi_server_test_run="agi_server_dev && bundle exec rake agi_server:test:run"
    alias agi_server_request="agi_server_dev && ruby ./script/agi_request.rb"
    # }}}
    # {{{ ami
    alias ami_dev="ruby2 && cd ~/git_clones/ami-fw-proxy"
    alias ami_run="ami_dev && RAILS_ENV=development JDEV=1 ruby -I /home/jcarson/git_clones/hosted-burnt43/ami_fw_proxy/ ./secure_multiplexer_proxy.rb"
    alias ami_sanity_checker="ami_dev && bundle exec ruby ./script/ami_sanity_checker.rb"
    # }}}
    # {{{ ami_client
    alias ami_client_dev="cd ~/git_clones/asterisk-manager-interface-client"
    alias ami_client_sample_run="ami_client_dev && bundle exec ruby -I~/git_clones/asterisk-manager-interface-client/lib ./sanity_checker.rb"
    alias ami_client_test_run="ami_client_dev && bundle exec rake ami_client:test:run"
    # }}}
    # {{{ ami_message_capture
    alias ami_message_capture_run="cd ~/git_clones/ami-message-capture && bundle exec ruby ./ami-message-capture.rb"
    # }}}
    # {{{ ami-replication
    alias ami_rep_dev="ruby2 && cd ~/git_clones/ami-replication"
    alias ami_rep_run="ami_rep_dev && ./script/ami-replication.sh"
    # }}}
    # {{{ ami_socket
    alias ami_socket_console="ami_socket_dev && ./script/console"
    alias ami_socket_dev="ruby2 && cd ~/git_clones/ami-socket"
    alias ami_socket_test_run="ami_socket_dev && bundle exec rake ami_socket:test:run"
    alias ami_socket_sanity_check="ami_socket_dev && ruby ./script/sanity_check.rb"
    # }}}
    # {{{ asterisk_cdr
    alias asterisk_cdr_console="asterisk_cdr_dev && ./script/console"
    alias asterisk_cdr_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/asterisk-cdr"
    alias asterisk_cdr_dev="ruby2 && cd ~/git_clones/asterisk-cdr"
    alias asterisk_cdr_syncer_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=jcarson_dev bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr/lib ./asterisk_cdr_syncer.rb"
    alias asterisk_cdr_finder_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=jcarson_dev bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr/lib ./asterisk_cdr_finder.rb"
    alias asterisk_cdr_data_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=jcarson_dev bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr/lib ./asterisk_cdr_data_processor.rb"
    alias asterisk_cdr_cli_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=jcarson_dev ASTERISK_CDR_EDITOR=/usr/bin/vim bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr/lib ./asterisk_cdr_cli.rb"
    alias asterisk_cdr_fraud_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=jcarson_dev bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr/lib ./asterisk_cdr_fraud.rb"
    alias asterisk_cdr_test_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=test bundle exec rake asterisk_cdr:test:run"
    # }}}
    # {{{ asterisk_config
    alias asterisk_config_dev="ruby2 && cd ~/git_clones/asterisk-config"
    alias asterisk_config_sample_run="asterisk_config_dev && bundle exec ruby -I./lib ./sanity_checker.rb"
    alias asterisk_config_test_run="asterisk_config_dev && bundle exec rake asterisk_config:test:run"
    # }}}
    # {{{ asterisk_database
    alias asterisk_database_dev="cd ~/git_clones/asterisk-database"
    alias asterisk_database_sample_run="asterisk_database_dev && bundle exec ruby -I./lib ./sanity_checker.rb"
    # }}}
    # {{{ asterisk_queue_ctl
    alias asterisk_queue_ctl_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/asterisk-queue-ctl"
    alias asterisk_queue_ctl_dev="ruby2 && cd /home/jcarson/git_clones/asterisk-queue-ctl"
    alias asterisk_queue_ctl_test_run="asterisk_queue_ctl_dev && ASTERISK_QUEUE_CTL_ENV=test bundle exec rake asterisk_queue_ctl:test:run"
    # }}}
    # {{{ auto_dialer
    alias auto_dialer_dev="ruby2 && cd ~/git_clones/auto_dialer"
    alias auto_dialer_run="auto_dialer_dev && AUTO_DIALER_ENV=development bundle exec ruby ./auto_dialer_server.rb"
    # }}}
    # {{{ bootstrap_helper
    alias bootstrap_helper_dev="cd ~/git_clones/bootstrap-helper-rails"
    alias bootstrap_helper_test_run="bootstrap_helper_dev && bundle exec rake bootstrap_helper_rails:test:run"
    # }}}
    # {{{ call_blaster
    alias call_blaster_dev="ruby2 && cd ~/git_clones/call_blaster"
    alias call_blaster_run="call_blaster_dev && bundle exec ruby ./call_blaster_server.rb"
    alias call_blaster_test_run="call_blaster_dev && CALL_BLASTER_ENV=test bundle exec rake call_blaster:test:run"
    # }}}
    # {{{ call_recorder
    alias call_recorder_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/call_recorder"
    alias call_recorder_dev="cd ~/git_clones/call_recorder"
    alias raudit_run="call_recorder_dev && RAUDIT_ENV=jcarson_dev ruby ./raudit/raudit.rb"
    # }}}
    # {{{ cli_builder
    alias cli_builder_dev="cd ~/git_clones/cli-builder"
    alias cli_builder_sample_run="cli_builder_dev && ruby -I/home/jcarson/git_clones/cli-builder/lib ./sanity_check_example.rb"
    alias cli_builder_test_run="cli_builder_dev && bundle exec rake cli_builder:test:run"
    # }}}
    # {{{ cti
    alias cti_dev="ruby2 && cd ~/git_clones/cti"
    alias cti_hpbxgui_run="cti_dev && CTI_ENV=development_hpbxgui ruby -I ./lib/ server.rb"
    alias cti_mtt_crm_run="cti_dev && CTI_ENV=development_mtt_crm ruby -I ./lib/ server.rb"
    # }}}
    # {{{ data_monitor
    alias data_monitor_dev="cd /home/jcarson/git_clones/data-monitor"
    alias data_monitor_test_run="data_monitor_dev && DATA_MONITOR_ENV=test THINGSPACE_API_RUBY_ENV=test bundle exec rake data_monitor:test:run"
    alias data_monitor_run="data_monitor_dev && XYMSRV=209.191.1.133 XYMON=/home/jcarson/xymon/bin/xymon DATA_MONITOR_ENV=development bundle exec ruby -I ./lib ./data_monitor.rb"
    # }}}
    # {{{ delayed
    alias delayed_dev="ruby2 && cd /home/jcarson/git_clones/delayed_job_scripts"
    # }}}
    # {{{ dns_record_changer
    alias dns_dev="ruby2 && cd ~/git_clones/dns-record-changer/"
    alias dns_test_run="dns_dev && DNS_ENV=test bundle exec rake dns_record_changer:test:run"
    alias dns_dev_reset="ruby2 && bundle exec rake dns_record_changer:dev:assets:reset"
    # }}}
    # {{{ engoncall
    alias engoncall_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/engoncall"
    alias engoncall_dev="ruby2 && cd ~/git_clones/engoncall"
    alias engoncall_test_run="engoncall_dev && ENGONCALL_ENV=test bundle exec rake engoncall:test:run"
    # }}}
    # {{{ eqpt_gui
    alias eqpt_gui_assets="eqpt_gui_dev && RAILS_ENV=jcarson_dev ./bin/dev"
    alias eqpt_gui_billing_link="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake billing:sync:addresses"
    alias eqpt_gui_console="eqpt_gui_dev && bundle exec rails console -e jcarson_dev"
    alias eqpt_gui_debug_server="eqpt_gui_dev && ./bin/rails server -e jcarson_dev -b 127.0.0.1 -u puma"
    alias eqpt_gui_deploy="ruby3 && __cap_deploy__ orderapp /home/orderapp/git_clones/eqpt-gui"
    alias eqpt_gui_delayed="eqpt_gui_dev && RAILS_ENV=jcarson_dev bin/delayed_job --exit-on-complete run"
    alias eqpt_gui_delayed_view="eqpt_gui_dev && mysql eqpt_gui_jcarson_dev --batch --skip-column-names -e \"SELECT handler FROM delayed_jobs;\" | /home/jcarson/git_clones/work-scripts/mtt/development/format_delayed_job.rb"
    alias eqpt_gui_dev="ruby3 && cd /home/jcarson/git_clones/eqpt-gui"
    alias eqpt_gui_db="eqpt_gui_dev && mysql eqpt_gui_jcarson_dev"

    # {{{ function __eqpt_gui_grep__ 
    function __eqpt_gui_grep__ {
      local search_term="$1"

      grep -R "$search_term" ./config ./lib ./test $(find ./app -mindepth 1 -maxdepth 1 -type d \! -name javascript \! -name assets)
    }
    # }}}
    # (e)qpt (g)ui (g)rep
    alias egg="eqpt_gui_dev && __eqpt_gui_grep__"

    alias eqpt_gui_log="eqpt_gui_dev && tail -f ./log/jcarson_dev.log"
    alias eqpt_gui_log_jcarson="eqpt_gui_dev && tail -f log/jcarson_dev.log | grep 'JCARSON'"
    alias eqpt_gui_log_req="eqpt_gui_dev && tail -f log/jcarson_dev.log | grep -B 1 -A 1 'Processing by'"
    alias eqpt_gui_reconcile="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake eqpt_gui:config:missing_equipment_category_permissions_for_users eqpt_gui:config:unconfigured_controller_actions eqpt_gui:config:unconfigured_authorization_aliases"
    alias eqpt_gui_restart="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake restart"
    alias eqpt_gui_rma_link="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake rma:sync:insert_and_assign"
    alias eqpt_gui_seed="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake eqpt_gui:seed:seed_development_from_production"
    alias eqpt_gui_test_run="eqpt_gui_dev && RAILS_ENV=test bundle exec rake eqpt_gui:test:run"
    alias eqpt_gui_test_schema_dump="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake eqpt_gui:test:dump_aux_db_schemas"
    alias eqpt_gui_travis_run="eqpt_gui_dev && RAILS_ENV=travis bundle exec rake eqpt_gui:test:run"
    # }}}
    # {{{ event_machine/faye
    alias faye_dev="ruby2 && cd ~/git_clones/faye"
    # }}}
    # {{{ hop
    alias hop_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/operator-panel"
    alias hop_dev="ruby2 && cd ~/git_clones/operator-panel"
    alias hop_run="hop_dev && HOP_ENV=jcarson_dev bundle exec ruby ./hop.rb"
    alias hop_run_ruby_3="hop_dev && HOP_ENV=development /usr/local/ruby/ruby-3.0.2/bin/bundle exec /usr/local/ruby/ruby-3.0.2/bin/ruby ./hop.rb"
    # }}}
    # {{{ hop_client
    # {{{ function __hop_client__ 
    function __hop_client__ {
      local username="$1"

      if [[ -z "$username" ]]; then
        # Just find the first session_id in the database.
        local session_id=$(mysql hpbx_indie_crm --skip-column-names --batch -e "SELECT session_id FROM sessions LIMIT 1;")
      else
        # Execute some minimal ruby code to find the session_id from the given
        # username.
        local session_id=$(hop_dev &&
        GEM_HOME=/home/jcarson/.gems/operator-panel/ruby/2.6.0 \
        GEM_PATH="" \
        /usr/local/ruby/ruby-2.6.1/bin/ruby \
        -r active_record \
        -r active_record/session_store \
        -r action_controller \
        -e "h={}; h['development']=YAML.load(IO.read('./config/env_config.yml')).dig('development', 'database'); ActiveRecord::Base.configurations = h; ActiveRecord::Base.establish_connection(:development); puts ActiveRecord::SessionStore::Session.all.find {|x| x.data['current_username'] == '$username'}&.session_id" \
        2>/dev/null)
      fi

      if [[ -z "$session_id" ]]; then
        # Generate a random bullshit session_id if we couldn't find one.
        local session_id=$(cat /dev/urandom | tr -c -d 'a-z0-9' | fold -w 32 | head -1)
      fi

      # Connect to the hop server using the session_id we found/generated.
      cd ~/git_clones/hop_js_client
      node ./hop_js_client.js wss://jcarson-hop.monmouth.com:11081 $session_id 2>/dev/null
    }
    # }}}
    alias hop_client_dev="cd ~/git_clones/hop_js_client"
    alias hop_client_run="__hop_client__"
    # }}}
    # {{{ hpbxgui (app)
    __rmagick_lib_path__=/usr/local/ImageMagick/6.9.12-34/lib
    __hpbxgui_test_db__=hpbxgui_test
    __hpbxgui_test_user__=hpbxgui_tester
    __hpbxgui_test_pass__=LfG*b95A8ehEQsr7
    __hpbxgui_test_socket__=/usr/local/mysql/mysql-5.7.21/data/mysql.sock 

    alias hpbxgui_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/hosted/hpbxgui"
    alias hpbxgui_bundle="LD_LIBRARY_PATH=\"${__rmagick_lib_path__}\" bundle"
    alias hpbxgui_console="hpbxgui_dev && hpbxgui_bundle exec rails console -e jcarson_dev"
    alias hpbxgui_dev="ruby2 && cd ~/git_clones/hosted/hpbxgui"
    alias hpbxgui_runner="hpbxgui_dev && hpbxgui_bundle exec rails runner -e jcarson_dev"
    alias hpbxgui_test_db_reset="hpbxgui_dev && RAILS_ENV=jcarson_dev JC_DB=${__hpbxgui_test_db__} JC_USER=${__hpbxgui_test_user__} JC_PASS=${__hpbxgui_test_pass__} JC_SOCK=${__hpbxgui_test_socket__} hpbxgui_bundle exec rake db:schema:dump && RAILS_ENV=hpbxgui_test JC_DB=${__hpbxgui_test_db__} JC_USER=${__hpbxgui_test_user__} JC_PASS=${__hpbxgui_test_pass__} JC_SOCK=${__hpbxgui_test_socket__} hpbxgui_bundle exec rake hpbxgui:test:db:reset"
    alias hpbxgui_test_run="hpbxgui_dev && RAILS_ENV=hpbxgui_test JC_DB=${__hpbxgui_test_db__} JC_USER=${__hpbxgui_test_user__} JC_PASS=${__hpbxgui_test_pass__} JC_SOCK=${__hpbxgui_test_socket__} hpbxgui_bundle exec rake hpbxgui:test:run"
    # }}}
    # {{{ httpd
    # {{{ function __httpd_ruby__
    function __httpd_ruby__ {
      local httpd_service_file=/usr/lib/systemd/system/httpd.service
      local ruby_major_version="$1"
      local systemctl_bin=/usr/bin/systemctl
      local sed_bin=/usr/bin/sed
      local httpd_service_name=httpd.service

      case "$ruby_major_version" in
        2)
          sudo $systemctl_bin stop $httpd_service_name && sudo $sed_bin -i 's/-DRuby3/-DRuby2/g' $httpd_service_file && sudo sed -i 's/^# Environment/Environment/g' $httpd_service_file && sudo $systemctl_bin daemon-reload && sudo $systemctl_bin start $httpd_service_name
          ;;
        3)
          sudo $systemctl_bin stop $httpd_service_name && sudo $sed_bin -i 's/-DRuby2/-DRuby3/g' $httpd_service_file && sudo sed -i 's/^Environment/# Environment/g' $httpd_service_file && sudo $systemctl_bin daemon-reload && sudo $systemctl_bin start $httpd_service_name
          ;;
      esac
    }
    # }}}
    # NOTE: If pacman overwrites the httpd systemd file. This is what is
    #   should look like to support httpd_ruby alias.
    # [Unit]
    # Description=Apache Web Server
    # After=network.target remote-fs.target nss-lookup.target

    # [Service]
    # Type=simple
    # ExecStart=/usr/bin/httpd -k start -DFOREGROUND -DRuby3
    # ExecStop=/usr/bin/httpd -k graceful-stop
    # ExecReload=/usr/bin/httpd -k graceful
    # PrivateTmp=true
    # LimitNOFILE=infinity
    # KillMode=mixed
    # # Environment=LD_LIBRARY_PATH=/usr/local/ImageMagick/6.9.12-34/lib

    # [Install]
    # WantedBy=multi-user.target
    alias httpd_ruby="__httpd_ruby__"
    # }}}
    # {{{ influxdb (gem)
    alias influxdb_dev="cd ~/git_clones/influxdb-client"
    alias influxdb_test_run="influxdb_dev && bundle exec rake influxdb_client:test:run"
    # }}}
    # {{{ lite_orm (gem)
    alias lite_orm_dev="cd ~/git_clones/lite-orm"
    alias lite_orm_test_run="lite_orm_dev && bundle exec rake lite_orm:test:run"
    # }}}
    # {{{ msteams_mon (app)
    alias msteams_mon_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/msteams-mon"
    alias msteams_mon_dev="ruby2 && cd ~/git_clones/msteams-mon"
    alias msteams_mon_run="msteams_mon_dev && ./script/msteams-mon"
    # }}}
    # {{{ mtt_crm (app)
    alias mtt_crm_clean_branches="~/gist_clones/git_branch_cleaner/git_branch_cleaner.sh ~/git_clones/mtt_crm-burnt43 mtt"
    alias mtt_crm_console="mtt_crm_dev && MTT_CRM_AUTO_LOAD_TENANT_ID=270 bundle exec rails console -e jcarson_dev"
    alias mtt_crm_dev="ruby2 && cd ~/git_clones/mtt_crm"
    alias mtt_crm_meta_test_run="mtt_crm_dev && RAILS_ENV=test bundle exec rake crm:test:meta:run"
    alias mtt_crm_runner="mtt_crm_dev && MTT_CRM_AUTO_LOAD_TENANT_ID=270 bundle exec rails runner -e jcarson_dev"
    alias mtt_crm_test_run="mtt_crm_dev && RAILS_ENV=test bundle exec rake crm:test:run"
    # }}}
    # {{{ rec_mon (app)
    alias rec_mon_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/rec-mon"
    alias rec_mon_dev="ruby2 && cd ~/git_clones/rec-mon"
    alias rec_mon_test_run="rec_mon_dev && bundle exec rake rec_mon:test:run"
    # }}}
    # {{{ rma (app)
    alias rma_dev="ruby2 && cd ~/git_clones/rma"
    alias rma_bundle="GEM_HOME=/home/jcarson/.gems/rma/ruby/2.6.0 GEM_PATH="" /home/jcarson/.gems/rma/ruby/2.6.0/bin/bundle"
    alias rma_git_ignore="rma_dev && git update-index --assume-unchanged Gemfile Gemfile.lock"
    # }}}
    # {{{ ruby_daemon_monitor (app)
    alias rdm_app_run="ruby_daemon_monitor_dev && RUBY_DAEMON_MONITOR_ENV=development_app ruby -I/home/jcarson/git_clones/ruby-daemon-monitor-burnt43/lib ./ruby_daemon_monitor.rb"
    alias rdm_crm_run="ruby_daemon_monitor_dev && RUBY_DAEMON_MONITOR_ENV=development_crm ruby -I/home/jcarson/git_clones/ruby-daemon-monitor-burnt43/lib ./ruby_daemon_monitor.rb"
    alias rdm_dev="ruby2 && cd ~/git_clones/ruby-daemon-monitor"
    alias rdm_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/ruby-daemon-monitor"
    # }}}
    # {{{ sip_utils (gem)
    alias sip_utils_dev="ruby2 && cd ~/git_clones/sip-utils"
    alias sip_utils_clearip_test="sip_utils_dev && bundle exec rake sip_utils:clearip:test"
    alias sip_utils_test_run="sip_utils_dev && bundle exec rake sip_utils:test:run"
    # }}}
    # {{{ softphone (app)
    alias softphone_dev="cd ~/git_clones/mtt-softphone"
    alias softphone_run="softphone_dev && npm run dev-start"
    alias softphone_test_run="softphone_dev && npm run test-clean && npm run test"
    # }}}
    # {{{ solr_mon (app)
    alias solr_mon_dev="ruby2 && cd ~/git_clones/solr-file-monitor"
    alias solr_mon_run="solr_mon_dev && SOLR_FILE_MONITOR_ENV=development ruby -I/home/jcarson/git_clones/solr-file-monitor-burnt43/lib -I/usr/local/ruby/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/bundler-2.0.2/lib/ ./file_monitor_daemon.rb"
    alias solr_mon_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/solr-file-monitor"
    alias solr_mon_start_daemon="solr_mon_dev && ./safe-solr-file-monitor"
    alias solr_mon_stop_daemon="ps aux | grep 'safe-solr-file-monitor' | grep -v 'grep' | awk '{print \$2}' | xargs -I pid kill -9 pid && ps aux | grep 'file_monitor_daemon\.rb' | grep -v 'grep' | awk '{print \$2}' | xargs -I pid kill -9 pid"
    alias solr_mon_test_run="solr_mon_dev && SOLR_FILE_MONITOR_ENV=test bundle exec rake solr_file_monitor:test:run"
    # }}}
    # {{{ stir-shaken-server (app)
    alias sss_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/stir-shaken-server"
    alias sss_dev="ruby2 && cd ~/git_clones/stir-shaken-server"
    alias sss_run="sss_dev && SSS_ENV=jcarson_dev bundle exec ruby -I./lib ./stir_shaken_server.rb"
    alias sss_test_run="sss_dev && SSS_ENV=test bundle exec rake sss:test:run"
    # }}}
    # {{{ thingspace (gem)
    alias thingspace_dev="ruby2 && cd /home/jcarson/git_clones/thingspace-api-ruby"
    alias thingspace_test_run="thingspace_dev && THINGSPACE_API_RUBY_ENV=test bundle exec rake thingspace_api_ruby:test:run"
    alias thingspace_sanity_check_run="thingspace_dev && script/console -c 'Thingspace::SanityCheck.run!'"
    # }}}
    # {{{ xymon (gem)
    alias xymon_dev="ruby2 && cd ~/git_clones/xymon"
    alias xymon_test_run="xymon_dev && bundle exec rake xymon:test:run"
    # }}}
    # {{{ xymon_reporter (app)
    alias xymon_reporter_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/xymon-reporter"
    alias xymon_reporter_dev="ruby2 && cd ~/git_clones/xymon-reporter"
    # }}}
    # }}}
    # {{{ Useful Helpers
    # {{{ alias ensure_mttpbx_virtual_server_exists
    function __ensure_mttpbx_virtual_server_exists__ {
      # +----+--------+--------------+------------------+------------------+-----------------+
      # | id | name   | ip           | hostname         | asterisk_version | type            |
      # +----+--------+--------------+------------------+------------------+-----------------+
      # | 13 | mttpbx | 209.191.9.13 | pbx.monmouth.com | 13               | HostedPBXServer |
      # +----+--------+--------------+------------------+------------------+-----------------+

      local db_name="$1"

      if [[ -z "$db_name" ]]; then
        db_name="hpbxgui_jcarson_dev"
      fi

      local virtual_server_table=$(mysql $db_name --batch --skip-column-names -e "SHOW TABLES LIKE '%virtual_servers%';")

      if [[ -z "$virtual_server_table" ]]; then
        return 1
      fi

      local pbx_count=$(mysql $db_name --batch --skip-column-names -e "SELECT COUNT(*) FROM virtual_servers WHERE name='mttpbx' AND ip='209.191.9.13' AND hostname='pbx.monmouth.com' AND asterisk_version='13' AND type='HostedPBXServer'";)

      if [[ "$pbx_count" == "0" ]]; then
        mysql $db_name -e "INSERT INTO virtual_servers SET name='mttpbx', ip='209.191.9.13', hostname='pbx.monmouth.com', asterisk_version='13', type='HostedPBXServer';"
      else
        return 0
      fi
    }
    alias ensure_mttpbx_virtual_server_exists="__ensure_mttpbx_virtual_server_exists__"
    # }}}
    # {{{ alias convert_to_ulaw
    function __convert_to_ulaw__ {
      local input_file="$1"
      local ffmpeg_bin="$(which ffmpeg)"
      local ulaw_file=$(echo "$input_file" | sed -r 's/^(.*)\.(.*)$/\1.ulaw/g')

      ${ffmpeg_bin} -y -i ${input_file} -ar 8000 -ac 1 -ab 64 -f mulaw ${ulaw_file} -map 0:0 1>/dev/null 2>/dev/null
    }
    alias convert_to_ulaw="__convert_to_ulaw__"
    # }}}
    # {{{ getpcap
    function __getpcap__ {
      local host="$1"
      local ssh_bin=$(which ssh 2>/dev/null)
      local scp_bin=$(which scp 2>/dev/null)

      local latest_pcap=$($ssh_bin $host "ls -t /home/jcarson/pcaps/* | head -1")
      local dst_dir=/home/jcarson/pcaps/${host}

      mkdir -p $dst_dir

      $scp_bin -l 10000 ${host}:${latest_pcap} $dst_dir
    }
    alias getpcap="__getpcap__"
    # }}}
    # {{{ alias git_xtract_dir
    function __git_extract_dir__ {
      :
      # I didn't get this working, but check out https://github.com/monmouthtelecom/call_blaster/wiki/Repo-from-Hosted-Subdir

      # local dir_to_move="$1"
      # local new_repo_url="$2"
      # local original_dir="$(pwd)"
      # local temp_remote_name=tmp_remote

      # [[ -z "$dir_to_move" ]] && echo -e "[\033[0;31mERROR\033[0;0m] - no dir_to_move provided" && cd $original_dir && return 1
      # [[ -z "$new_repo_url" ]] && echo -e "[\033[0;31mERROR\033[0;0m] - no new_repo_url provided" && cd $original_dir && return 1

      # [[ ! -e "./${dir_to_move}" ]] && echo -e "[\033[0;31mERROR\033[0;0m] - dir_to_move does not exist" && cd $original_dir && return 1

      # local git_bin=$(which git)
      # local git_filter_repo_url=git@github.com:newren/git-filter-repo.git
      # local git_filter_bin=~/git_clones/git-filter-repo/git-filter-repo

      # if [[ -e ~/git_clones/git-filter-repo ]]; then
      #   cd ~/git_clones/git-filter-repo && $git_bin pull
      # elif [[ -e ~/git_clones ]]; then
      #   cd ~/git_clones && $git_bin clone $git_filter_repo_url
      # fi

      # $git_bin remote add $temp_remote_name $new_repo_url
      # $git_bin fetch $temp_remote_name
      # $git_bin pull $temp_remote_name master
      # $git_bin push -u $temp_remote_name 
      # $git_filter_bin --path $dir_to_move
      # $git_filter_bin --subdirectory-filter $dir_to_move

      # # $git_bin remote remove $temp_remote_name

      # cd $original_dir
    }
    alias git_xtract_dir="__git_extract_dir__"
    # }}}
    # {{{ alias imagemagick_pkgconfig
    function __imagemagick_pkgconfig__ {
      local version="$1"
      local imagemagick6_dir=/usr/local/ImageMagick/6.9.12-34/lib/pkgconfig
      local imagemagick7_dir=/usr/lib/imagemagick7/pkgconfig
      local pkgconfig_dir=/usr/lib/pkgconfig

      echo -n "moving existing imagemagick pc files out of $pkgconfig_dir..."
      sudo find $pkgconfig_dir -maxdepth 1 -type f -name '*Magick*.pc' -exec mv {} /home/jcarson/.tmp \;
      sudo find $pkgconfig_dir -maxdepth 1 -type f -name '*Wand*.pc' -exec mv {} /home/jcarson/.tmp \;
      ([[ "$?" != "0" ]] && echo -e "\033[0;31mFAIL\033[0;0m" && return 1) || echo -e "\033[0;32mOK\033[0;0m"

      case "$version" in
        6)
          echo -n "moving pc files in $imagemagick6_dir to $pkgconfig_dir..."
          sudo cp ${imagemagick6_dir}/*.pc $pkgconfig_dir
          ([[ "$?" != "0" ]] && echo -e "\033[0;31mFAIL\033[0;0m" && return 1) || echo -e "\033[0;32mOK\033[0;0m"
          ;;
        7)
          echo -n "moving pc files in $imagemagick7_dir to $pkgconfig_dir..."
          sudo cp ${imagemagick7_dir}/*.pc $pkgconfig_dir
          ([[ "$?" != "0" ]] && echo -e "\033[0;31mFAIL\033[0;0m" && return 1) || echo -e "\033[0;32mOK\033[0;0m"
          ;;
      esac
    }
    alias imagemagick_pkgconfig="__imagemagick_pkgconfig__"
    # }}}
    # {{{ alias listen_to_latest_dev_recording
    function __listen_to_latest_dev_recording__ {
      local year="$(date +'%Y')"
      local month="$(date +'%m')"
      local day="$(date +'%d')"

      local remote_server="mg3"

      local ssh_bin="$(which ssh)"
      local scp_bin="$(which scp)"
      local ffmpeg_bin="$(which ffmpeg)"
      local mplayer_bin="$(which mplayer)"

      local remote_dir="/rec/monitor/mttpbx/$year/$month/$day"
      local local_dir="/home/jcarson/.tmp"
      local latest_recording="$($ssh_bin $remote_server "ls -lt $remote_dir\/*.ulaw" | head -1 | awk '{print $9}')"
      local local_filename_without_extension="$local_dir/$(basename --suffix=.ulaw $latest_recording)"

      if [[ ! -z "$latest_recording" ]]; then
        echo "$latest_recording"
        $scp_bin -l 10000 -q $remote_server:$latest_recording $local_dir
        $ffmpeg_bin -y -f mulaw -ar 8000 -ac 1 -i ${local_filename_without_extension}.ulaw -ar 44100 -ac 2 ${local_filename_without_extension}.wav
        $mplayer_bin ${local_filename_without_extension}.wav
      fi
    }
    alias listen_to_latest_dev_recording="__listen_to_latest_dev_recording__"
    # }}}
    alias minicom="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 minicom@mtt3"
    # {{{ alias mk_mail_dir
    function __mk_mail_dir__ {
      local dirname="$1"
      mkdir -p /home/jcarson/Mail/INBOX/${dirname}/{cur,new,tmp}
      chmod -R 0700 /home/jcarson/Mail/INBOX/${dirname}
    }
    alias mk_mail_dir="__mk_mail_dir__"
    # }}}
    # {{{ alias mount_rwolflaw/umount_rwolflaw
    if [[ -f ~/.rwolflaw_samba_pass ]]; then
      alias mount_rwolflaw="sudo mkdir -p /mnt/rwolflaw && sudo mount -t cifs //gs5.monmouth.com/rwolflaw /mnt/rwolflaw -o 'username=rwolflaw,password=$(cat ~/.rwolflaw_samba_pass),vers=1.0'"
      alias umount_rwolflaw="sudo umount /mnt/rwolflaw && sudo rm -R /mnt/rwolflaw"
    fi
    # }}}
    # {{{ alias spectra2/mount_spectra2/umount_spectra2
    if [[ -f ~/.spectra2_pass ]]; then
      alias spectra2="/usr/bin/rdesktop -u Administrator -p  spectra2 -g 1028x768 200.255.100.185"
      alias mount_spectra2="sudo mkdir -p /mnt/spectra2 && sudo mount -t cifs //200.255.100.185/spectra2 /mnt/spectra2 -o 'username=Administrator,password=$(cat ~/.spectra2_pass),vers=1.0'"
      alias umount_spectra2="sudo umount /mnt/spectra2 && sudo rm -R /mnt/spectra2"
    fi
    # }}}
    # {{{ alias sync_hpbxgui_session_id
    function __sync_hpbxgui_session_id__ {
      local my_hpbxgui_user="$1"
      [[ -z "$my_hpbxgui_user" ]] && my_hpbxgui_user=mttpbx-284

      local mysql_bin=$(which mysql)
      local ruby_bin=$(which ruby)

      local p_db_user=$(cat ~/.lapaz/mysql-read-only-production-user)
      local p_db_pass=$(cat ~/.lapaz/mysql-read-only-production-pass)
      local p_db_host=hosted-db
      local p_db_base=hpbx_production

      local d_db_user=$(cat ~/.lapaz/mysql-local-dev-user)
      local d_db_pass=$(cat ~/.lapaz/mysql-local-dev-pass)
      local d_db_base=hpbxgui_jcarson_dev

      local record_found=0
      local first_iteration=1

      IFS=$'\n'

      # Look for session_id in production.
      for row in $($mysql_bin -u $p_db_user -p${p_db_pass} -h $p_db_host $p_db_base --skip-column-names --batch -e "SELECT session_id, data FROM sessions WHERE created_at != updated_at ORDER BY updated_at DESC LIMIT 1000;"); do
        [[ "$first_iteration" == "1" ]] && echo -n "looking for session in production database..."
        first_iteration=0

        local production_session_id=$(echo "$row" | awk '{print $1}')
        local enc=$(echo "$row" | awk '{print $2}')

        local possible_hpbxgui_user=$($ruby_bin -rbase64 -e "puts (Base64.decode64(\"${enc}\") =~ /${my_hpbxgui_user}/)")
        [[ -z "$possible_hpbxgui_user" ]] && continue

        record_found=1
        echo -e "\033[0;32mOK\033[0;0m"
        echo -e "[\033[0;34mINFO\033[0;0m] - found production_session_id: \033[0;32m${production_session_id}\033[0;0m"
        break
      done

      first_iteration=1

      if [[ "$record_found" == "1" ]]; then
        record_found=0

        # Look for session_id in development.
        for row in $($mysql_bin -u $d_db_user -p${d_db_pass} $d_db_base --skip-column-names --batch -e "SELECT session_id, data FROM sessions WHERE created_at != updated_at ORDER BY updated_at DESC LIMIT 100;"); do
          [[ "$first_iteration" == "1" ]] && echo -n "looking for session in development database..."
          first_iteration=0

          local development_session_id=$(echo "$row" | awk '{print $1}')
          local enc=$(echo "$row" | awk '{print $2}')

          local possible_hpbxgui_user=$($ruby_bin -rbase64 -e "puts (Base64.decode64(\"${enc}\") =~ /${my_hpbxgui_user}/)")
          [[ -z "$possible_hpbxgui_user" ]] && continue

          record_found=1
          echo -e "\033[0;32mOK\033[0;0m"
          echo -e "[\033[0;34mINFO\033[0;0m] - found development_session_id: \033[0;32m${development_session_id}\033[0;0m"
          break
        done

        if [[ "$record_found" == "1" ]]; then
          # Update the development session_id to be the same as production.
          $mysql_bin -u $d_db_user -p${d_db_pass} $d_db_base -e "UPDATE sessions SET session_id='$production_session_id' WHERE session_id='$development_session_id';"
          echo -e "[\033[0;34mINFO\033[0;0m] - Updated development session."
          echo -e "[\033[0;34mINFO\033[0;0m] - Remember to set the browser's cookie to use session_id: \033[0;32m$production_session_id\033[0;0m"
        else
          echo -e "\033[0;31mFAIL\033[0;0m"
        fi
      else
        echo -e "\033[0;31mFAIL\033[0;0m"
      fi
    }
    alias sync_hpbxgui_session_id="__sync_hpbxgui_session_id__"
    # }}}
    # {{{ alias sync_ssh_config
    function __sync_ssh_config__ {
      local f="/home/jcarson/.ssh/config"
      local users=(asterisk orderapp)

      for u in "${users[@]}"; do
        sudo cp $f /home/$u/.ssh/config
        sudo chown $u:$u /home/$u/.ssh/config
      done
    }
    alias sync_ssh_config="__sync_ssh_config__"
    # }}}
    alias t38router="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostKeyAlgorithms=+ssh-dss -c 3des-cbc 64.19.145.26"
    # {{{ alias text2speech
    function __text2speech__ {
      # Possible Voices
      # en-US_AllisonVoice,
      # en-US_AllisonV3Voice,
      # en-US_EmilyV3Voice,
      # en-US_HenryV3Voice,
      # en-US_KevinV3Voice,
      # en-US_LisaVoice,
      # en-US_LisaV3Voice,
      # en-US_MichaelVoice,
      # en-US_MichaelV3Voice,
      # en-US_OliviaV3Voice

      local msg="$1"
      local voice="$2"

      case "$voice" in
        allison) text2speech_voice="en-US_AllisonV3Voice" ;;
        emily) text2speech_voice="en-US_EmilyV3Voice" ;;
        lisa) text2speech_voice="en-US_LisaV3Voice" ;;
        olivia) text2speech_voice="en-US_OliviaV3Voice" ;;
        *)
          voice=lisa
          text2speech_voice="en-US_LisaV3Voice"
          ;;
      esac

      local text2speech_output=$(echo "$msg" | sed 's/ /-/g')
      local text2speech_text=$(echo "$msg" | sed 's/ /%20/g')
      local test2speech_accept="audio%2Fwav"
      local text2speech_api_url="https://api.us-east.text-to-speech.watson.cloud.ibm.com/instances/afbf1900-fd96-4d18-beec-8fca13a6cf51/v1/synthesize"
      local text2speech_api_key=$(cat ~/.text2speech-api-key)

      text2speech_output="${voice}-${text2speech_output}.wav"

      # echo "curl -X GET -u \"apikey:${text2speech_api_key}\" --output ${text2speech_output} \"${text2speech_api_url}?accept=${test2speech_accept}&text=${text2speech_text}&voice=${text2speech_voice}\""
      curl -X GET -u "apikey:${text2speech_api_key}" --output ${text2speech_output} "${text2speech_api_url}?accept=${test2speech_accept}&text=${text2speech_text}&voice=${text2speech_voice}"
    }
    alias text2speech="__text2speech__"
    # }}}
    alias xymon_ctl="XYMSRV=209.191.1.133 XYMON=/home/jcarson/xymon/bin/xymon /home/jcarson/git_clones/xymon/script/xymon_ctl.sh"
    # }}}
    # {{{ Recompile Aliases (After pacman -Syu)
    # {{{ function __compile_mcl__ 
    function __compile_mcl__ {
      # Find where the possibly upgraded perl libperl.so is.
      local installed_libperl=$(find /usr/lib/perl5 -type f -name 'libperl.so' | head -1)
      [[ -z "$installed_libperl" ]] && return 0

      # Where the system thinks libperl.so is.
      local system_libperl=/usr/lib/libperl.so

      # Link the system libperl to the new libperl
      sudo rm $system_libperl && sudo ln -s $installed_libperl $system_libperl

      local mcl_source_dir=/home/jcarson/sources/mcl_64bit/mcl-0.53.00

      cd $mcl_source_dir && make distclean && ./configure --disable-python && make && sudo make install
    }
    # }}}
    alias compile_mcl="__compile_mcl__"

    alias recompile_mysql_5="cd ~/sources/mysql-5.7.21 && cmake --install-prefix=/usr/local/mysql/mysql-5.7.21 -DWITH_BOOST=~/sources/boost_1_59_0.tar.gz ./ && make"

    # {{{ function __recompile_passenger__ 
    function __recompile_passenger__ {
      # Find the bundle path, because this is where the gems are installed.
      # We're looking for the passenger gem for this project.
      local bundle_path_output=$(bundle config get path | tail -1)

      # See if the output is configured or not. If not configured, then bail
      # out.
      echo "$bundle_path_output" | grep -q "^You have not configured"
      [[ "$?" == "0" ]] && __echo_error__ "no bundle path configured" && return

      # If the path was configured, then extract it out. If nothing found,
      # then bail out.
      local bundle_path=$(echo "$bundle_path_output" | cut -d: -f2 | sed 's/^..//' | sed 's/.$//')
      [[ -z "$bundle_path" ]] && __echo_error__ "no bundle path configured" && return

      # Find the passenger gem path. Sort and get the last result, this should
      # theoretically be the latest version of passenger. If no result, then
      # bail out.
      local passenger_path=$(find $bundle_path/ruby/*/gems -name 'passenger-*' -type d | sort | tail -1)
      [[ -z "$passenger_path" ]] && __echo_error__ "no passenger path found" && return

      # Look for the apache install script. If it does not exist, then bail out.
      local passenger_install_script="$passenger_path/bin/passenger-install-apache2-module" 
      [[ ! -e "$passenger_install_script" ]] && __echo_error__ "could not find install script" && return

      # From the passenger gem path, bubble up to get the gem_home. We need
      # this so when we run the install script it can find the gems from
      # our project.
      local gem_home=$(dirname $(dirname "$passenger_path"))

      # Run the install script, which will compile the passenger module for apache.
      GEM_HOME="$gem_home" GEM_PATH="" $passenger_path/bin/passenger-install-apache2-module
    }
    # }}}
    alias recompile_passenger="__recompile_passenger__"

    # {{{ function __recompile_ruby__ 
    function __recompile_ruby__ {
      local ruby_version="$1"

      [[ -z "$ruby_version" ]] && ruby_version=$(ruby -v | awk '{print $2}' | cut -dp -f1)

      local ruby_source_dir="/home/jcarson/sources/ruby-$ruby_version"

      [[ ! -e $ruby_source_dir ]] && __echo_error__ "could not find ruby_source_dir '$ruby_source_dir'" && return

      cd $ruby_source_dir && make clean && make && sudo make install
    }
    # }}}
    alias recompile_ruby="__recompile_ruby__"
    # }}}
    ;;
    # }}}
esac
# {{{ Aliases.Global
alias conf_file_text="which figlet && figlet -w 100 -f /usr/share/figlet/fonts/big.flf"

# {{{ function __change_terminal_title__ 
function __change_terminal_title__ {
  local name="$1"
  xdotool search --name jcarson set_window --name "$name"
}
# }}}
# (c)hange (t)erminal (t)itle
alias ctt="__change_terminal_title__"

# (e)xtract (f)ile(n)ames
alias efn="awk -F ':' '{print \$1}' | sort | uniq"

which gem 1>/dev/null 2>/dev/null && alias gem_dir="cd $(gem environment | grep -e '- INSTALLATION DIRECTORY:' | sed 's/^.*: //g')"

# {{{ function __genpass__ 
function __genpass__ {
  local len="$1"
  cat /dev/urandom | tr -d -c 'A-Za-z0-9%*&' | fold -w $len | head -1
}
# }}}
alias genpass="__genpass__"

# {{{ function __git_first_push__ 
function __git_first_push__ {
  __echo_proc_step__ "pushing"
  git push --quiet --set-upstream origin $(git branch --show-current) 1>/dev/null 2>/dev/null
  ([[ "$?" == "0" ]] && __echo_ok__) || (__echo_fail__ && return 1)
}
# }}}
alias git_first_push="__git_first_push__"
alias gfp="__git_first_push__"

# {{{ function __git_sync_master__ 
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
# }}}
alias git_sync_master="__git_sync_master__"
alias gsm="__git_sync_master__"

# {{{ __git_prep_deploy__
function __git_prep_deploy__ {
  local git_bin=$(which git)

  if [[ $($git_bin branch --list stable | wc -l) == 0 ]]; then
    __echo_proc_step__ "checking out master"
    $git_bin checkout master --quiet
    ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

    __echo_proc_step__ "pulling"
    $git_bin pull --quiet
    ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__
  else
    __echo_proc_step__ "checking out master"
    $git_bin checkout master --quiet
    ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

    __echo_proc_step__ "pulling"
    $git_bin pull --quiet
    ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

    __echo_proc_step__ "checking out stable"
    $git_bin checkout stable --quiet
    ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

    __echo_proc_step__ "merging master -> stable"
    $git_bin merge --no-edit --no-ff --quiet master
    ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__

    __echo_proc_step__ "pushing stable"
    $git_bin push --quiet
    ([[ "$?" == "0" ]] && __echo_ok__) || __echo_fail__
  fi
}
# }}}
alias git_prep_deploy="__git_prep_deploy__"

alias gits="git status --short"
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias ruby_file_text="which figlet && figlet -w 100 -f /usr/share/figlet/fonts/standard.flf"
alias sbrc="source ~/.bashrc"
alias script_banner_text="which figlet 1>/dev/null 2>/dev/null && [[ -e "/usr/share/figlet/fonts/banner.flf" ]] && figlet -w 100 -f /usr/share/figlet/fonts/banner.flf"
alias systemd_top="top -p \$(ps aux | grep 'systemd' | grep -v "grep" | awk '{print \$2}' | paste -sd,)"
# }}}
# }}}
# {{{ Exports
case "$(hostname)" in
  # {{{ Exports.burnt43
  burnt43)
    # Clear out the PATH
    export PATH=""

    # List of directories to add to the path in ascending order of priority.
    my_paths=(
      /usr/bin/core_perl
      /usr/bin/vendor_perl
      /usr/bin/site_perl
      /usr/bin
      /usr/local/bin
      /usr/local/sbin
      /usr/local/ruby/ruby-3.1.1/bin
      /usr/local/mysql/mysql-5.7.21/bin/
      /usr/local/openssh/openssh-8.1p1/bin/
      /home/jcarson/.npm-packages/bin
      /home/jcarson/.gems/eqpt-gui/ruby/3.1.0/gems/passenger-6.0.12/bin
      /home/jcarson/git_clones/work-scripts/personal
      /home/jcarson/git_clones/work-scripts/mtt/development
    )

    # Iterate and add to the PATH.
    for p in "${my_paths[@]}"; do
      [[ ! -e "$p" ]] && continue 

      if [[ -z "$(echo $PATH)" ]]; then
        export PATH="$p"
      else
        export PATH="${p}:$PATH"
      fi
    done

    export CVSROOT=:pserver:anonymous@cvs:/var/lib/cvs

    # golang
    export GOPATH=$HOME/go

    # JRE 8
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/java-8-openjdk/jre/lib/amd64/:/usr/lib/jvm/java-8-openjdk/jre/lib/amd64/server

    # JRE 10 # export JAVA_HOME=/usr/lib/jvm/java-10-openjdk
    ;;
  # }}}
esac
# {{{ Exports.Global
export LANG=en_US.UTF-8
export EDITOR='vim'
export XDG_CONFIG_HOME=$HOME/.config
# }}}
# }}}
# {{{ Shell Welcome Text
# {{{ function __print_md__ 
function __print_md__ {
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
# }}}
# {{{ function __print_fetch__ 
function __print_fetch__ {
  which neofetch 1>/dev/null 2>/dev/null && neofetch
}
# }}}
__print_md__
# }}}
