#          _
#         | |
#  _______| |__  _ __ ___
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__
# /___|___/_| |_|_|  \___|
#

# machine-specific zsh options {{{
case "$(hostname)" in
# {{{ burnt43
burnt43)
  ZSH=/usr/share/oh-my-zsh/
  ZSH_THEME="jcarson-work"
  ;;
# }}}
# {{{ jco2
jco2)
  ZSH=$HOME/.oh-my-zsh
  ZSH_THEME="jcarson-home"
  ;;
# }}}
# {{{ jcrsn01
jcrsn01)
  ZSH=$HOME/.oh-my-zsh
  ZSH_THEME="jcarson-virtual"
# }}}
esac
# }}}

# {{{ global zsh options
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
ZSH_CUSTOM=~/.oh-my-zsh/custom
# }}}

# global plugins {{{
plugins=(
  git
  vi-mode
)
# }}}

# {{{ distro-specific stuff
case "$(hostname)" in
  jcrsn01)
    # Manually override, because uname -r doesn't give me the info I want.
    JCRSN_DISTRO="centos"
    ;;
  *)
    JCRSN_DISTRO=$(uname -r | awk -F '-' '{print $2}')
    ;;
esac

case "$JCRSN_DISTRO" in
centos)
  function centos_pkg_install {
    local pkg_name="$1"
    sudo dnf install $pkg_name
  }
  function centos_pkg_list {
    local pkg_name="$1"
    dnf list installed $pkg_name
  }
  function centos_pkg_remove {
    local pkg_name="$1"
    sudo dnf remove $pkg_name
  }

  alias pkg-install="centos_pkg_install"
  alias pkg-list="centos_pkg_list"
  alias pkg-remove="centos_pkg_remove"
  ;;
gentoo)
  function yes_no_prompt {
    echo -en "[\033[0;31mINPUT REQUIRED\033[0;0m] - $1 (Y/n): "
    read yes_no_choice

    if [[ "$yes_no_choice" == "Y" ]]; then
      return 0
    else
      return 1
    fi
  }

  function gentoo_pkg_install {
    local pkg_name="$1"
    sudo emerge --ask $pkg_name
  }
  function gentoo_pkg_list {
    local pkg_name="$1"
    qlist -IRv $pkg_name
  }
  function gentoo_pkg_remove {
    local pkg_name="$1"
    sudo emerge --deselect $pkg_name
    sudo emerge --depclean -vp

    yes_no_prompt "continue with emerge --depclean -v?" 
    local rval="$?"
    if [[ "$rval" == "0" ]]; then
      sudo emerge --depclean -v
    fi
  }

  alias pkg-install="gentoo_pkg_install"
  alias pkg-list="gentoo_pkg_list"
  alias pkg-remove="gentoo_pkg_remove"
  ;;
esac
# }}}

# machine-specific shell stuff {{{
JCRSN_GIT_CLONE_DIR=/home/jcarson/git_clones

case "$(hostname)" in
# {{{ burnt43
burnt43)
  export PATH=$PATH:~/sources/solr-8.2.0/solr/bin:/home/jcarson/.gems/mtt-crm/ruby/2.6.0/bin:/usr/local/ruby/ruby-2.6.1/bin:/usr/local/mysql/mysql-5.7.21/bin:~/git_clones/git-filter-repo:~/bin:~/git_clones/personal-scripts
  export CVSROOT=:pserver:anonymous@cvs:/var/lib/cvs

  # golang
  export GOPATH=$HOME/go

  # JRE 8
  export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/java-8-openjdk/jre/lib/amd64/:/usr/lib/jvm/java-8-openjdk/jre/lib/amd64/server

  # JRE 10 # export JAVA_HOME=/usr/lib/jvm/java-10-openjdk

  alias ami_dev="cd ~/git_clones/hosted-burnt43/ami_fw_proxy"
  alias ami_run="ami_dev && RAILS_ENV=development JDEV=1 ruby -I /home/jcarson/git_clones/hosted-burnt43/ami_fw_proxy/ ./secure_multiplexer_proxy.rb"

  alias hpbxgui_dev="cd ~/git_clones/hosted-burnt43/hpbxgui"
  alias hpbxgui_test_run="hpbxgui_dev && RAILS_ENV=hpbxgui_test bundle exec rake hpbxgui:test:run"

  alias cti_dev="cd ~/git_clones/cti-burnt43"
  alias cti_hpbxgui_run="cti_dev && CTI_ENV=development_hpbxgui ruby -I ./lib/ server.rb"
  alias cti_mtt_crm_run="cti_dev && CTI_ENV=development_mtt_crm ruby -I ./lib/ server.rb"

  alias ami_client_dev="cd ~/git_clones/asterisk-manager-interface-client"
  alias ami_client_sample_run="ami_client_dev && bundle exec ruby -I~/git_clones/asterisk-manager-interface-client/lib ./sanity_checker.rb"
  alias ami_client_test_run="ami_client_dev && bundle exec rake ami_client:test:run"

  alias ami_message_capture_run="cd ~/git_clones/ami-message-capture && bundle exec ruby ./ami-message-capture.rb"

  alias asterisk_cdr_dev="cd ~/git_clones/asterisk-cdr-burnt43"
  alias asterisk_cdr_syncer_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=development bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr-burnt43/lib ./asterisk_cdr_syncer.rb"
  alias asterisk_cdr_finder_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=development bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr-burnt43/lib ./asterisk_cdr_finder.rb"
  alias asterisk_cdr_data_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=development bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr-burnt43/lib ./asterisk_cdr_data_processor.rb"
  alias asterisk_cdr_cli_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=devprod ASTERISK_CDR_EDITOR=/usr/bin/vim bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr-burnt43/lib ./asterisk_cdr_cli.rb"
  alias asterisk_cdr_fraud_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=development bundle exec ruby -I/home/jcarson/git_clones/asterisk-cdr-burnt43/lib ./asterisk_cdr_fraud.rb"
  alias asterisk_cdr_test_run="asterisk_cdr_dev && ASTERISK_CDR_ENV=test bundle exec rake asterisk_cdr:test:run"

  alias asterisk_config_dev="cd ~/git_clones/asterisk-config"
  alias asterisk_config_sample_run="asterisk_config_dev && bundle exec ruby -I./lib ./sanity_checker.rb"

  alias asterisk_database_dev="cd ~/git_clones/asterisk-database"
  alias asterisk_database_sample_run="asterisk_database_dev && bundle exec ruby -I./lib ./sanity_checker.rb"

  alias cli_builder_dev="cd ~/git_clones/cli-builder"
  alias cli_builder_sample_run="cli_builder_dev && ruby -I/home/jcarson/git_clones/cli-builder/lib ./sanity_check_example.rb"
  alias cli_builder_test_run="cli_builder_dev && bundle exec rake cli_builder:test:run"

  alias solr_mon_dev="cd ~/git_clones/solr-file-monitor-burnt43"
  alias solr_mon_run="solr_mon_dev && SOLR_FILE_MONITOR_ENV=development ruby -I/home/jcarson/git_clones/solr-file-monitor-burnt43/lib -I/usr/local/ruby/ruby-2.6.1/lib/ruby/gems/2.6.0/gems/bundler-2.0.2/lib/ ./file_monitor_daemon.rb"
  alias solr_mon_test="solr_mon_dev && SOLR_FILE_MONITOR_ENV=test bundle exec rake solr_file_monitor:test:run"
  alias solr_mon_start_daemon="solr_mon_dev && ./safe-solr-file-monitor"
  alias solr_mon_stop_daemon="ps aux | grep 'safe-solr-file-monitor' | grep -v 'grep' | awk '{print \$2}' | xargs -I pid kill -9 pid && ps aux | grep 'file_monitor_daemon\.rb' | grep -v 'grep' | awk '{print \$2}' | xargs -I pid kill -9 pid"

  alias solr_start="solr start"

  alias hop_dev="cd ~/git_clones/operator-panel-burnt43"
  alias hop_run="hop_dev && HOP_ENV=development bundle exec ruby ./hop.rb"
  alias hop_run_ruby_3="hop_dev && HOP_ENV=development /usr/local/ruby/ruby-3.0.2/bin/bundle exec /usr/local/ruby/ruby-3.0.2/bin/ruby ./hop.rb"

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
  alias hop_client_dev="cd ~/git_clones/hop_js_client"
  alias hop_client_run="__hop_client__"

  function __ensure_mttpbx_virtual_server_exists__ {
    # +----+--------+--------------+------------------+------------------+-----------------+
    # | id | name   | ip           | hostname         | asterisk_version | type            |
    # +----+--------+--------------+------------------+------------------+-----------------+
    # | 13 | mttpbx | 209.191.9.13 | pbx.monmouth.com | 13               | HostedPBXServer |
    # +----+--------+--------------+------------------+------------------+-----------------+

    local db_name="$1"

    if [[ -z "$db_name" ]]; then
      db_name="hpbx_indie_crm"
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

  alias ruby_daemon_monitor_dev="cd ~/git_clones/ruby-daemon-monitor-burnt43"
  alias ruby_daemon_monitor_app_run="ruby_daemon_monitor_dev && RUBY_DAEMON_MONITOR_ENV=development_app ruby -I/home/jcarson/git_clones/ruby-daemon-monitor-burnt43/lib ./ruby_daemon_monitor.rb"
  alias ruby_daemon_monitor_crm_run="ruby_daemon_monitor_dev && RUBY_DAEMON_MONITOR_ENV=development_crm ruby -I/home/jcarson/git_clones/ruby-daemon-monitor-burnt43/lib ./ruby_daemon_monitor.rb"
  alias ruby_daemon_monitor_release="cd ~/git_clones/ruby-daemon-monitor-monmouthtelecom && git checkout master && git pull && git checkout stable && git pull && git merge --no-ff master && git push && sudo su asterisk -c 'cd /home/jcarson/git_clones/ruby-daemon-monitor-monmouthtelecom && bundle exec cap production deploy'"

  alias mtt_crm_dev="cd ~/git_clones/mtt_crm-burnt43/"
  alias mtt_crm_test_run="mtt_crm_dev && RAILS_ENV=test bundle exec rake crm:test:run"
  alias mtt_crm_meta_test_run="mtt_crm_dev && RAILS_ENV=test bundle exec rake crm:test:meta:run"
  alias mtt_crm_clean_branches="~/gist_clones/git_branch_cleaner/git_branch_cleaner.sh ~/git_clones/mtt_crm-burnt43 mtt"

  alias call_blaster_dev="cd ~/git_clones/hosted-burnt43/call_blaster"
  alias call_blaster_run="call_blaster_dev && bundle exec ruby ./call_blaster_server.rb"

  alias softphone_dev="cd ~/git_clones/mtt-softphone-burnt43"
  alias softphone_run="softphone_dev && npm start"

  alias crm_git_add_all="git add app/models app/controllers app/mailers app/views app/helpers app/assets/javascripts config lib test"

  alias mount_rwolflaw="sudo mkdir -p /mnt/rwolflaw && sudo mount -t cifs //gs5.monmouth.com/rwolflaw /mnt/rwolflaw -o 'username=rwolflaw,password=$(cat ~/.rwolflaw_samba_pass),vers=1.0'"
  alias umount_rwolflaw="sudo umount /mnt/rwolflaw && sudo rm -R /mnt/rwolflaw"

  alias ssh_old="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1"
  alias scp_old="scp -oKexAlgorithms=+diffie-hellman-group1-sha1"

  alias minicom="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 minicom@mtt3"
  alias t38router="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostKeyAlgorithms=+ssh-dss -c 3des-cbc 64.19.145.26"

  alias restore_production_mttpbx="ls ~/.database_dumps/mtt_crm/production/*_270.mysqldump | xargs -I dumpfile bash -c \"echo -e -n 'restoring \033[0;33mdumpfile\033[0;0m...' && mysql mtt_crm_indie_crm < dumpfile && echo -e '\033[0;32mOK\033[0;0m'\""
  alias restore_production_randy="ls ~/.database_dumps/mtt_crm/production/*_320.mysqldump | xargs -I dumpfile bash -c \"echo -e -n 'restoring \033[0;33mdumpfile\033[0;0m...' && mysql mtt_crm_indie_crm < dumpfile && echo -e '\033[0;32mOK\033[0;0m'\""

  # mysql-5.7.21 aliases

  # using ~/.mylogin.cnf so this is obsolete
  # alias mysql="/usr/local/mysql/mysql-5.7.21/bin/mysql --defaults-file=/usr/local/mysql/mysql-5.7.21/user/my.cnf"

  # using ~/.mylogin.cnf so this is obsolete
  # alias mysqldump="/usr/local/mysql/mysql-5.7.21/bin/mysqldump --defaults-file=/usr/local/mysql/mysql-5.7.21/user/my.cnf"

  alias stop_mysql="[ -e /usr/local/mysql/mysql-5.7.21/user/mysqld.pid ] && pkill --signal 9 --pidfile /usr/local/mysql/mysql-5.7.21/user/mysqld.pid"
  alias start_mysql="/usr/local/mysql/mysql-5.7.21/bin/mysqld --defaults-file=/usr/local/mysql/mysql-5.7.21/user/my.cnf --daemonize --pid-file=/usr/local/mysql/mysql-5.7.21/user/mysqld.pid"
  alias mysql_socket="sudo mkdir -p /run/mysqld && [ ! -e /run/mysqld/mysqld.sock ] && sudo ln -s /usr/local/mysql/mysql-5.7.21/user/mysqld.sock /run/mysqld/mysqld.sock"

  alias spectra2="/usr/bin/rdesktop -u Administrator -p  spectra2 -g 1028x768 200.255.100.185"
  alias mount_spectra2="sudo mkdir -p /mnt/spectra2 && sudo mount -t cifs //200.255.100.185/spectra2 /mnt/spectra2 -o 'username=Administrator,password=$(cat ~/.spectra2_pass),vers=1.0'"
  alias umount_spectra2="sudo umount /mnt/spectra2 && sudo rm -R /mnt/spectra2"
  ;;
# }}}
# {{{ jco2
jco2)
  export PATH=$PATH:/home/jcarson/.gem/ruby/2.5.0/bin
  export GPG_TTY=$(tty)

  alias vpn="sudo openvpn --config /home/jcarson/vpn/vpn2-UDP4-1200-jcarson-config.ovpn"
  alias work_machine="ssh 200.255.100.116"

  alias mount_sd="udisksctl mount -b /dev/sdc1"
  alias umount_sd="udisksctl unmount -b /dev/sdc1"

  alias keyboard_rate="xset -display :0 r rate 350 50"

  alias dmti_dev="cd /home/jcarson/git_clones/dmti"
  alias dmti_run="dmti_dev && bundle exec ruby -I/home/jcarson/git_clones/dmti/lib dmti.rb"

  ;;
# }}}
# {{{ jcrsn01
jcrsn01)
  export PATH=$PATH:/usr/local/ruby/3.0.1/bin
# }}}
esac

# add my script repo to the path
if [[ ! -z "$JCRSN_GIT_CLONE_DIR" ]]; then
  export PATH=$PATH:$JCRSN_GIT_CLONE_DIR/work-scripts-burnt43/personal:$JCRSN_GIT_CLONE_DIR/work-scripts-burnt43/mtt/development
fi
# }}}

# global exports {{{
export LANG=en_US.UTF-8
export EDITOR='vim'
export XDG_CONFIG_HOME=$HOME/.config
# }}}

# global aliases {{{
alias grep="grep --color=auto"
alias awk_filenames_from_grep="awk -F ':' '{print $1}' | sort | uniq"

which gem 1>/dev/null 2>/dev/null
if [[ $? == 0 ]]; then
  alias gem_dir="cd $(gem environment | grep -e '- INSTALLATION DIRECTORY:' | sed 's/^.*: //g')"
fi

alias conf_file_text="which figlet && figlet -w 100 -f /usr/share/figlet/fonts/big.flf"
alias script_banner_text="which figlet 1>/dev/null 2>/dev/null && [[ -e "/usr/share/figlet/fonts/banner.flf" ]] && figlet -w 100 -f /usr/share/figlet/fonts/banner.flf"
# }}}

# cache and source {{{
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh
# }}}

# global unsets {{{
unsetopt share_history
# }}}

# global keybinds {{{
# vi-mode fixes
# unbind ALL keys in viins mode and only bind jk to command mode
bindkey -rM viins "^["
bindkey -M viins 'jk' vi-cmd-mode

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

bindkey "^[w" forward-word
bindkey "^[d^[w" kill-word
bindkey "^[b" backward-word
bindkey "^[d^[b" backward-kill-word

bindkey "^[d^[d" kill-whole-line
bindkey "^[h" beginning-of-line
bindkey "^[l" end-of-line

bindkey "^L" clear-screen
# }}}

# print on shell start {{{
# use neofetch as a welcome message
which neofetch 2>/dev/null && neofetch
# }}}

# use : to have the last command return 0 so when I source this file I can
# get a successful return code.
:
