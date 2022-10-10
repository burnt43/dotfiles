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
  [[ ! -e "./.git" ]] && return

  local branch=$(git branch | grep '^*' | cut -d' ' -f2)
  local changes_present=$(git status . | grep -E "(^Changes|^Untracked)" | wc -l)

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
# {{{ Aliases
case "$(hostname)" in
  # {{{ Aliases.burnt43
  burnt43)
    # {{{ Development Software Run/Test Helpers
    alias ruby2='source $(rubyv -v 2.6.10)'
    alias ruby3='source $(rubyv -v 3.1.1)'

    alias ami_dev="cd ~/git_clones/hosted-burnt43/ami_fw_proxy"
    alias ami_run="ami_dev && RAILS_ENV=development JDEV=1 ruby -I /home/jcarson/git_clones/hosted-burnt43/ami_fw_proxy/ ./secure_multiplexer_proxy.rb"

    alias ami_client_dev="cd ~/git_clones/asterisk-manager-interface-client"
    alias ami_client_sample_run="ami_client_dev && bundle exec ruby -I~/git_clones/asterisk-manager-interface-client/lib ./sanity_checker.rb"
    alias ami_client_test_run="ami_client_dev && bundle exec rake ami_client:test:run"

    alias ami_message_capture_run="cd ~/git_clones/ami-message-capture && bundle exec ruby ./ami-message-capture.rb"

    alias ami_socket_dev="cd ~/git_clones/ami-socket"
    alias ami_socket_test_run="ami_socket_dev && bundle exec rake ami_socket:test:run"
    alias ami_socket_console="ami_socket_dev && ./script/console"

    alias asterisk_cdr_dev="cd ~/git_clones/asterisk-cdr"
    alias asterisk_cdr_syncer_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=development bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr/lib ./asterisk_cdr_syncer.rb"
    alias asterisk_cdr_finder_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=development bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr/lib ./asterisk_cdr_finder.rb"
    alias asterisk_cdr_data_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=development bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr/lib ./asterisk_cdr_data_processor.rb"
    alias asterisk_cdr_cli_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=devprod ASTERISK_CDR_EDITOR=/usr/bin/vim bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr/lib ./asterisk_cdr_cli.rb"
    alias asterisk_cdr_fraud_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=development bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr/lib ./asterisk_cdr_fraud.rb"
    alias asterisk_cdr_test_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=test bundle exec rake asterisk_cdr:test:run"

    alias asterisk_config_dev="cd ~/git_clones/asterisk-config"
    alias asterisk_config_sample_run="asterisk_config_dev && bundle exec ruby -I./lib ./sanity_checker.rb"

    alias asterisk_database_dev="cd ~/git_clones/asterisk-database"
    alias asterisk_database_sample_run="asterisk_database_dev && bundle exec ruby -I./lib ./sanity_checker.rb"

    alias asterisk_queue_ctl_dev="cd /home/jcarson/git_clones/asterisk-queue-ctl"
    alias asterisk_queue_ctl_test_run="asterisk_queue_ctl_dev && ASTERISK_QUEUE_CTL_ENV=test bundle exec rake asterisk_queue_ctl:test:run"

    alias auto_dialer_dev="cd ~/git_clones/hosted-burnt43/auto_dialer"
    alias auto_dialer_run="auto_dialer_dev && AUTO_DIALER_ENV=development bundle exec ruby ./auto_dialer_server.rb"

    alias bootstrap_helper_dev="cd ~/git_clones/bootstrap-helper-rails"
    alias bootstrap_helper_test_run="bootstrap_helper_dev && bundle exec rake bootstrap_helper_rails:test:run"

    alias call_blaster_dev="cd ~/git_clones/call_blaster"
    alias call_blaster_run="call_blaster_dev && bundle exec ruby ./call_blaster_server.rb"
    alias call_blaster_test_run="call_blaster_dev && CALL_BLASTER_ENV=test bundle exec rake call_blaster:test:run"

    alias call_recording_dev="cd ~/git_clones/call_recorder"

    alias cli_builder_dev="cd ~/git_clones/cli-builder"
    alias cli_builder_sample_run="cli_builder_dev && ruby -I/home/jcarson/git_clones/cli-builder/lib ./sanity_check_example.rb"
    alias cli_builder_test_run="cli_builder_dev && bundle exec rake cli_builder:test:run"

    alias cti_dev="cd ~/git_clones/cti"
    alias cti_hpbxgui_run="cti_dev && CTI_ENV=development_hpbxgui ruby -I ./lib/ server.rb"
    alias cti_mtt_crm_run="cti_dev && CTI_ENV=development_mtt_crm ruby -I ./lib/ server.rb"

    alias data_monitor_dev="cd /home/jcarson/git_clones/data-monitor"
    alias data_monitor_test_run="data_monitor_dev && DATA_MONITOR_ENV=test THINGSPACE_API_RUBY_ENV=test bundle exec rake data_monitor:test:run"
    alias data_monitor_run="data_monitor_dev && XYMSRV=209.191.1.133 XYMON=/home/jcarson/xymon/client/bin/xymon DATA_MONITOR_ENV=development bundle exec ruby -I ./lib ./data_monitor.rb"

    alias engoncall_dev="cd ~/git_clones/engoncall"
    alias engoncall_test_run="engoncall_dev && ENGONCALL_ENV=test bundle exec rake engoncall:test:run"

    alias eqpt_gui_billing_link="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake billing:sync:addresses"
    alias eqpt_gui_console="eqpt_gui_dev && bundle exec rails console -e jcarson_dev"
    alias eqpt_gui_dev="ruby3 && cd /home/jcarson/git_clones/eqpt-gui"
    alias eqpt_gui_reconcile="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake eqpt_gui:config:missing_equipment_category_permissions_for_users eqpt_gui:config:unconfigured_controller_actions eqpt_gui:config:unconfigured_authorization_aliases"
    alias eqpt_gui_rma_link="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake rma:sync:insert_and_assign"
    alias eqpt_gui_seed="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake eqpt_gui:seed:seed_development_from_production"
    alias eqpt_gui_test_run="eqpt_gui_dev && RAILS_ENV=test bundle exec rake eqpt_gui:test:run"
    alias eqpt_gui_test_schema_dump="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake eqpt_gui:test:dump_aux_db_schemas"
    alias eqpt_gui_travis_run="eqpt_gui_dev && RAILS_ENV=travis bundle exec rake eqpt_gui:test:run"

    alias hop_dev="cd ~/git_clones/operator-panel"
    alias hop_run="hop_dev && HOP_ENV=development bundle exec ruby ./hop.rb"
    alias hop_run_ruby_3="hop_dev && HOP_ENV=development /usr/local/ruby/ruby-3.0.2/bin/bundle exec /usr/local/ruby/ruby-3.0.2/bin/ruby ./hop.rb"

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

    alias hpbxgui_bundle="LD_LIBRARY_PATH=\"/usr/local/ImageMagick/6.9.12-34/lib\" bundle"
    alias hpbxgui_console="hpbxgui_dev && hpbxgui_bundle exec rails console -e jcarson_dev"
    alias hpbxgui_dev="ruby2 && cd ~/git_clones/hosted/hpbxgui"
    alias hpbxgui_test_db_reset="hpbxgui_dev && RAILS_ENV=jcarson_dev hpbxgui_hundle exec rake db:schema:dump && RAILS_ENV=hpbxgui_test bundle exec rake hpbxgui:test:db:reset"
    alias hpbxgui_test_run="hpbxgui_dev && RAILS_ENV=hpbxgui_test bundle exec rake hpbxgui:test:run"

    alias httpd_ruby="__httpd_ruby__"

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

    alias influxdb_dev="cd ~/git_clones/influxdb-client"
    alias influxdb_test_run="influxdb_dev && bundle exec rake influxdb_client:test:run"

    alias lite_orm_dev="cd ~/git_clones/lite-orm"
    alias lite_orm_test_run="lite_orm_dev && bundle exec rake lite_orm:test:run"

    alias mtt_crm_dev="ruby2 && cd ~/git_clones/mtt_crm"
    alias mtt_crm_test_run="mtt_crm_dev && RAILS_ENV=test bundle exec rake crm:test:run"
    alias mtt_crm_meta_test_run="mtt_crm_dev && RAILS_ENV=test bundle exec rake crm:test:meta:run"
    alias mtt_crm_clean_branches="~/gist_clones/git_branch_cleaner/git_branch_cleaner.sh ~/git_clones/mtt_crm-burnt43 mtt"
    alias mtt_crm_console="mtt_crm_dev && bundle exec rails console -e jcarson_dev"

    alias rec_mon_dev="cd ~/git_clones/rec-mon"
    alias rec_mon_test_run="rec_mon_dev && bundle exec rake rec_mon:test:run"

    alias ruby_daemon_monitor_dev="cd ~/git_clones/ruby-daemon-monitor"
    alias ruby_daemon_monitor_app_run="ruby_daemon_monitor_dev && RUBY_DAEMON_MONITOR_ENV=development_app ruby -I/home/jcarson/git_clones/ruby-daemon-monitor-burnt43/lib ./ruby_daemon_monitor.rb"
    alias ruby_daemon_monitor_crm_run="ruby_daemon_monitor_dev && RUBY_DAEMON_MONITOR_ENV=development_crm ruby -I/home/jcarson/git_clones/ruby-daemon-monitor-burnt43/lib ./ruby_daemon_monitor.rb"
    alias ruby_daemon_monitor_release="cd ~/git_clones/ruby-daemon-monitor-monmouthtelecom && git checkout master && git pull && git checkout stable && git pull && git merge --no-ff master && git push && sudo su asterisk -c 'cd /home/jcarson/git_clones/ruby-daemon-monitor-monmouthtelecom && bundle exec cap production deploy'"

    alias softphone_dev="cd ~/git_clones/mtt-softphone"
    alias softphone_run="softphone_dev && npm start"

    alias solr_mon_dev="cd ~/git_clones/solr-file-monitor"
    alias solr_mon_run="solr_mon_dev && SOLR_FILE_MONITOR_ENV=development ruby -I/home/jcarson/git_clones/solr-file-monitor-burnt43/lib -I/usr/local/ruby/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/bundler-2.0.2/lib/ ./file_monitor_daemon.rb"
    alias solr_mon_test="solr_mon_dev && SOLR_FILE_MONITOR_ENV=test bundle exec rake solr_file_monitor:test:run"
    alias solr_mon_start_daemon="solr_mon_dev && ./safe-solr-file-monitor"
    alias solr_mon_stop_daemon="ps aux | grep 'safe-solr-file-monitor' | grep -v 'grep' | awk '{print \$2}' | xargs -I pid kill -9 pid && ps aux | grep 'file_monitor_daemon\.rb' | grep -v 'grep' | awk '{print \$2}' | xargs -I pid kill -9 pid"

    alias thingspace_dev="cd /home/jcarson/git_clones/thingspace-api-ruby"
    alias thingspace_test_run="thingspace_dev && THINGSPACE_API_RUBY_ENV=test bundle exec rake thingspace_api_ruby:test:run"
    alias thingspace_sanity_check_run="thingspace_dev && script/console -c 'Thingspace::SanityCheck.run!'"
    # }}}

    # {{{ Useful Helpers
    # {{{ function __ensure_mttpbx_virtual_server_exists__ 
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
    # }}}
    alias ensure_mttpbx_virtual_server_exists="__ensure_mttpbx_virtual_server_exists__"

    if [[ -f ~/.rwolflaw_samba_pass ]]; then
      alias mount_rwolflaw="sudo mkdir -p /mnt/rwolflaw && sudo mount -t cifs //gs5.monmouth.com/rwolflaw /mnt/rwolflaw -o 'username=rwolflaw,password=$(cat ~/.rwolflaw_samba_pass),vers=1.0'"
      alias umount_rwolflaw="sudo umount /mnt/rwolflaw && sudo rm -R /mnt/rwolflaw"
    fi

    if [[ -f ~/.spectra2_pass ]]; then
      alias spectra2="/usr/bin/rdesktop -u Administrator -p  spectra2 -g 1028x768 200.255.100.185"
      alias mount_spectra2="sudo mkdir -p /mnt/spectra2 && sudo mount -t cifs //200.255.100.185/spectra2 /mnt/spectra2 -o 'username=Administrator,password=$(cat ~/.spectra2_pass),vers=1.0'"
      alias umount_spectra2="sudo umount /mnt/spectra2 && sudo rm -R /mnt/spectra2"
    fi

    # {{{ function __text2speech__ 
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
    # }}}
    alias text2speech="__text2speech__"

    # {{{ function __convert_to_ulaw__ 
    function __convert_to_ulaw__ {
      local input_file="$1"
      local ffmpeg_bin="$(which ffmpeg)"
      local ulaw_file=$(echo "$input_file" | sed -r 's/^(.*)\.(.*)$/\1.ulaw/g')

      ${ffmpeg_bin} -y -i ${input_file} -ar 8000 -ac 1 -ab 64 -f mulaw ${ulaw_file} -map 0:0 1>/dev/null 2>/dev/null
    }
    # }}}
    alias convert_to_ulaw="__convert_to_ulaw__"

    # {{{ function __mk_mail_dir__ 
    function __mk_mail_dir__ {
      local dirname="$1"
      mkdir -p /home/jcarson/Mail/INBOX/${dirname}/{cur,new,tmp}
      chmod -R 0700 /home/jcarson/Mail/INBOX/${dirname}
    }
    # }}}
    alias mk_mail_dir="__mk_mail_dir__"

    alias xymon_ctl="XYMSRV=209.191.1.133 XYMON=/home/jcarson/xymon/client/bin/xymon /home/jcarson/git_clones/xymon-burnt43/script/xymon_ctl.sh"

    alias minicom="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 minicom@mtt3"

    alias t38router="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostKeyAlgorithms=+ssh-dss -c 3des-cbc 64.19.145.26"

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
    alias imagemagick_pkfconfig="__imagemagick_pkgconfig__"

    # {{{ function __sync_ssh_config__
    function __sync_ssh_config__ {
      local f="/home/jcarson/.ssh/config"
      local users=(asterisk orderapp)

      for u in "${users[@]}"; do
        sudo cp $f /home/$u/.ssh/config
        sudo chown $u:$u /home/$u/.ssh/config
      done
    }
    # }}}
    alias sync_ssh_config="__sync_ssh_config__"
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

    alias compile_mysql_5="cd ~/sources/mysql-5.7.21 && cmake --install-prefix=/usr/local/mysql/mysql-5.7.21 -DWITH_BOOST=~/sources/boost_1_59_0.tar.gz ./ && make"
    # }}}
    ;;
    # }}}
esac
# {{{ Aliases.Global
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias awk_filenames_from_grep="awk -F ':' '{print $1}' | sort | uniq"

which gem 1>/dev/null 2>/dev/null
if [[ $? == 0 ]]; then
  alias gem_dir="cd $(gem environment | grep -e '- INSTALLATION DIRECTORY:' | sed 's/^.*: //g')"
fi

alias conf_file_text="which figlet && figlet -w 100 -f /usr/share/figlet/fonts/big.flf"
alias script_banner_text="which figlet 1>/dev/null 2>/dev/null && [[ -e "/usr/share/figlet/fonts/banner.flf" ]] && figlet -w 100 -f /usr/share/figlet/fonts/banner.flf"
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

__print_fetch__
__print_md__
# }}}
