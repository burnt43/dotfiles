alias compile_mcl="__compile_mcl__"
alias convert_to_ulaw="__convert_to_ulaw__"
alias ensure_mttpbx_virtual_server_exists="__ensure_mttpbx_virtual_server_exists__"
alias getpcap="__getpcap__"
alias git_xtract_dir="__git_extract_dir__"
alias imagemagick_pkgconfig="__imagemagick_pkgconfig__"
alias listen_to_latest_dev_recording="__listen_to_latest_dev_recording__"
alias minicom="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 minicom@mtt3"
alias mk_mail_dir="__mk_mail_dir__"
alias recompile_mysql_5="cd ~/sources/mysql-5.7.21 && cmake --install-prefix=/usr/local/mysql/mysql-5.7.21 -DWITH_BOOST=~/sources/boost_1_59_0.tar.gz ./ && make"
alias recompile_passenger="__recompile_passenger__"
alias recompile_ruby="__recompile_ruby__"
alias reset_httpd="__ngrok_shuffle__ all"
alias sync_hpbxgui_session_id="__sync_hpbxgui_session_id__"
alias sync_ssh_config="__sync_ssh_config__"
alias t38router="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostKeyAlgorithms=+ssh-dss -c 3des-cbc 64.19.145.26"
alias text2speech="__text2speech__"
alias xymon_ctl="XYMSRV=209.191.1.133 XYMON=/home/jcarson/xymon/bin/xymon /home/jcarson/git_clones/xymon/script/xymon_ctl.sh"

function __convert_to_ulaw__ {
  local input_file="$1"
  local ffmpeg_bin="$(which ffmpeg)"
  local ulaw_file=$(echo "$input_file" | sed -r 's/^(.*)\.(.*)$/\1.ulaw/g')

  ${ffmpeg_bin} -y -i ${input_file} -ar 8000 -ac 1 -ab 64 -f mulaw ${ulaw_file} -map 0:0 1>/dev/null 2>/dev/null
}

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

function __getpcap__ {
  local host="$1"
  local ssh_bin=$(which ssh 2>/dev/null)
  local scp_bin=$(which scp 2>/dev/null)

  local latest_pcap=$($ssh_bin $host "ls -t /home/jcarson/pcaps/* | head -1")
  local dst_dir=/home/jcarson/pcaps/${host}

  mkdir -p $dst_dir

  $scp_bin -l 10000 ${host}:${latest_pcap} $dst_dir
}

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

function __mk_mail_dir__ {
  local dirname="$1"
  mkdir -p /home/jcarson/Mail/INBOX/${dirname}/{cur,new,tmp}
  chmod -R 0700 /home/jcarson/Mail/INBOX/${dirname}
}

if [[ -f ~/.rwolflaw_samba_pass ]]; then
  alias mount_rwolflaw="sudo mkdir -p /mnt/rwolflaw && sudo mount -t cifs //gs5.monmouth.com/rwolflaw /mnt/rwolflaw -o 'username=rwolflaw,password=$(cat ~/.rwolflaw_samba_pass),vers=1.0'"
  alias umount_rwolflaw="sudo umount /mnt/rwolflaw && sudo rm -R /mnt/rwolflaw"
fi

if [[ -f ~/.spectra2_pass ]]; then
  alias spectra2="/usr/bin/rdesktop -u Administrator -p  spectra2 -g 1028x768 200.255.100.185"
  alias mount_spectra2="sudo mkdir -p /mnt/spectra2 && sudo mount -t cifs //200.255.100.185/spectra2 /mnt/spectra2 -o 'username=Administrator,password=$(cat ~/.spectra2_pass),vers=1.0'"
  alias umount_spectra2="sudo umount /mnt/spectra2 && sudo rm -R /mnt/spectra2"
fi

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

function __sync_ssh_config__ {
  local f="/home/jcarson/.ssh/config"
  local users=(asterisk orderapp)

  for u in "${users[@]}"; do
    sudo cp $f /home/$u/.ssh/config
    sudo chown $u:$u /home/$u/.ssh/config
  done
}


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

function __recompile_passenger__ {
  # Find the bundle path, because this is where the gems are installed.
  # We're looking for the passenger gem for this project.
  local bundle_path_output=$(bundle config path | tail -1)

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

function __recompile_ruby__ {
  local ruby_version="$1"

  [[ -z "$ruby_version" ]] && ruby_version=$(ruby -v | awk '{print $2}' | cut -dp -f1)

  local ruby_source_dir="/home/jcarson/sources/ruby-$ruby_version"

  [[ ! -e $ruby_source_dir ]] && __echo_error__ "could not find ruby_source_dir '$ruby_source_dir'" && return

  cd $ruby_source_dir && make clean && make && sudo make install
}
