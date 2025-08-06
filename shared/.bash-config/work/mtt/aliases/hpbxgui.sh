__rmagick_lib_path__=/usr/local/ImageMagick/6.9.12-34/lib
__hpbxgui_test_db__=hpbxgui_test
__hpbxgui_test_user__=hpbxgui_tester
__hpbxgui_test_pass__=LfG*b95A8ehEQsr7
__hpbxgui_test_socket__=/usr/local/mysql/mysql-5.7.21/data/mysql.sock 

# NOTE: This probably should have been a test in the hpbxgui.
function __hpbxgui_test_sia__ {
  # associative arrays
  declare -A hpbxgui_sia_passwords
  declare -A hpbxgui_db

  # bins to use.
  local awk_bin=$(which awk)
  local curl_bin=$(which curl)
  local grep_bin=$(which grep)
  local mysql_bin=$(which mysql)
  local sed_bin=$(which sed)

  # other vars.
  local bad_password="this_is_not_a_password_for_anything"
  local my_config_file=/home/jcarson/git_clones/hosted/hpbxgui/config/environments/jcarson_dev.rb
  local my_db_config_file=/home/jcarson/git_clones/hosted/hpbxgui/config/database.yml

  # Access sensitive info that cannot be in plain-text in this file.
  hpbxgui_db[host]=$($grep_bin -A 6 '^jcarson_dev:' $my_db_config_file | grep -E '^\s*host:' | $awk_bin '{print $2}')
  hpbxgui_db[database]=$($grep_bin -A 6 '^jcarson_dev:' $my_db_config_file | grep -E '^\s*database:' | $awk_bin '{print $2}')
  hpbxgui_db[username]=$($grep_bin -A 6 '^jcarson_dev:' $my_db_config_file | grep -E '^\s*username:' | $awk_bin '{print $2}')
  hpbxgui_db[password]=$($grep_bin -A 6 '^jcarson_dev:' $my_db_config_file | grep -E '^\s*password:' | $awk_bin '{print $2}')

  # Grep out passwords from existing files, so we don't have them in plain
  # text in this file which maybe is in a public repo.
  hpbxgui_sia_passwords[chat_messages___send_text_message]=$($grep_bin "config.send_text_message_password" $my_config_file | $awk_bin '{print $3}' | $sed_bin 's/^.//' | $sed_bin 's/.$//g')
  hpbxgui_sia_passwords[eqpt_gui_api__sip___registrations]=$($grep_bin "config.eqpt_gui_api_password" $my_config_file | $awk_bin '{print $3}' | $sed_bin 's/^.//' | $sed_bin 's/.$//g')

  # This password is not static, it changes depending on the chat message media.
  # That is why it is safe to have in plain text in this file.
  hpbxgui_sia_passwords[chat_message_medias___external_access]=HhU6cWcFr9

  # Insert a chat_message_media record so we can test external_access.
  # The external_access password is the access_hash column of the
  # record we want external access for.
  local chat_message_media_id=$($mysql_bin -u ${hpbxgui_db[username]} -p${hpbxgui_db[password]} -h ${hpbxgui_db[host]} ${hpbxgui_db[database]} --batch --skip-column-names -e "INSERT INTO chat_message_medias (media_ordinal, filename, content_type, media_data, access_hash) VALUES (1, 'bipbop.deleteme', 'application/text', '0', '${hpbxgui_sia_passwords[chat_message_medias___external_access]}');SELECT LAST_INSERT_ID();")

  # ChatMessagesController#send_text_message GOOD PASSWORD
  __echo_proc_step__ "\033[0;33mtesting\033[0;0m \033[0;35mChatMessagesController\033[0;0m#\033[0;36msend_text_message\033[0;0m (good password)"
  curl_result=$($curl_bin -X POST -o /dev/null -s -w "%{http_code}\n" https://jcarson-hpbxgui.monmouth.com/chat_messages/0/send_text_message --data-urlencode "password=${hpbxgui_sia_passwords[chat_messages___send_text_message]}")
  ([[ "$curl_result" == "200" ]] && __echo_ok__) || __echo_fail__

  # ChatMessagesController#send_text_message BAD PASSWORD
  __echo_proc_step__ "\033[0;33mtesting\033[0;0m \033[0;35mChatMessagesController\033[0;0m#\033[0;36msend_text_message\033[0;0m (bad password)"
  curl_result=$($curl_bin -X POST -o /dev/null -s -w "%{http_code}\n" https://jcarson-hpbxgui.monmouth.com/chat_messages/0/send_text_message --data-urlencode "password=${bad_password}")
  ([[ "$curl_result" != "200" ]] && __echo_ok__) || __echo_fail__

  # ChatMessageMediasController#external_access GOOD PASSWORD
  __echo_proc_step__ "\033[0;33mtesting\033[0;0m \033[0;35mChatMessageMediasController\033[0;0m#\033[0;36mexternal_access\033[0;0m (good password)"
  curl_result=$($curl_bin -X GET -o /dev/null -s -w "%{http_code}\n" https://jcarson-hpbxgui.monmouth.com/chat_message_media/${chat_message_media_id}/external_access --data-urlencode "password=${hpbxgui_sia_passwords[chat_message_medias___external_access]}")
  ([[ "$curl_result" == "200" ]] && __echo_ok__) || __echo_fail__

  # ChatMessageMediasController#external_access BAD PASSWORD
  __echo_proc_step__ "\033[0;33mtesting\033[0;0m \033[0;35mChatMessageMediasController\033[0;0m#\033[0;36mexternal_access\033[0;0m (bad password)"
  curl_result=$($curl_bin -X GET -o /dev/null -s -w "%{http_code}\n" https://jcarson-hpbxgui.monmouth.com/chat_message_media/${chat_message_media_id}/external_access --data-urlencode "password=${bad_password}")
  ([[ "$curl_result" != "200" ]] && __echo_ok__) || __echo_fail__

  # EqptGuiApi::SipController#registrations GOOD PASSWORD
  __echo_proc_step__ "\033[0;33mtesting\033[0;0m \033[0;35mEqptGuiApi::SipController\033[0;0m#\033[0;36mregistrations\033[0;0m (good password)"
  curl_result=$($curl_bin -X GET -o /dev/null -s -w "%{http_code}\n" https://jcarson-hpbxgui.monmouth.com/eqpt_gui_api/sip/registrations --data-urlencode "password=${hpbxgui_sia_passwords[eqpt_gui_api__sip___registrations]}")
  ([[ "$curl_result" == "200" ]] && __echo_ok__) || __echo_fail__

  # EqptGuiApi::SipController#registrations BAD PASSWORD
  __echo_proc_step__ "\033[0;33mtesting\033[0;0m \033[0;35mEqptGuiApi::SipController\033[0;0m#\033[0;36mregistrations\033[0;0m (bad password)"
  curl_result=$($curl_bin -X GET -o /dev/null -s -w "%{http_code}\n" https://jcarson-hpbxgui.monmouth.com/eqpt_gui_api/sip/registrations --data-urlencode "password=${bad_password}")
  ([[ "$curl_result" != "200" ]] && __echo_ok__) || __echo_fail__

  # ChatMessagesController#access_chat_javascript NO PASSWORD
  __echo_proc_step__ "\033[0;33mtesting\033[0;0m \033[0;35mChatMessagesController\033[0;0m#\033[0;36maccess_chat_javascript\033[0;0m (no password)"
  curl_result=$($curl_bin -X GET -o /dev/null -s -w "%{http_code}\n" https://jcarson-hpbxgui.monmouth.com/chat_messages/access_chat_javascript)
  ([[ "$curl_result" == "200" ]] && __echo_ok__) || __echo_fail__

  # Remove the chat_message_media record we added
  $mysql_bin -u ${hpbxgui_db[username]} -p${hpbxgui_db[password]} -h ${hpbxgui_db[host]} ${hpbxgui_db[database]} -e "DELETE FROM chat_message_medias WHERE id=${chat_message_media_id}"
}

function __hpbxgui_permission_diff__ {
  local pfile=~/.lapaz/mysql

  local mysql_username_for_production=$(grep "^solo_lectura" $pfile | head -1 | cut -d\( -f1)
  local mysql_password_for_production=$(grep "^solo_lectura" $pfile | head -1 | awk '{print $2}')
  local mysql_host_for_production=hosted-db
  local mysql_db_for_production=hpbx_production

  local grep_after=6
  local dev_env_name=jcarson_dev
  local database_config_file=./config/database.yml

  local mysql_username_for_dev=$(grep -A $grep_after "^${dev_env_name}:" $database_config_file | grep -E '^\s*username' | awk '{print $2}')
  local mysql_password_for_dev=$(grep -A $grep_after "^${dev_env_name}:" $database_config_file | grep -E '^\s*password' | awk '{print $2}')
  local mysql_host_for_dev=$(grep -A $grep_after "^${dev_env_name}:" $database_config_file | grep -E '^\s*host' | awk '{print $2}')
  local mysql_db_for_dev=$(grep -A $grep_after "^${dev_env_name}:" $database_config_file | grep -E '^\s*database' | awk '{print $2}')

  local production_result_filename=/tmp/hpbxgui-permission-diff-production.txt
  local dev_result_filename=/tmp/hpbxgui-permission-diff-dev.txt

  mysql -u $mysql_username_for_production -p${mysql_password_for_production} -h $mysql_host_for_production $mysql_db_for_production --skip-column-names --batch -e "SELECT name FROM permissions ORDER BY name;" | sort > $production_result_filename
  mysql -u $mysql_username_for_dev -p${mysql_password_for_dev} -h $mysql_host_for_dev $mysql_db_for_dev --skip-column-names --batch -e "SELECT name FROM permissions ORDER BY name;" | sort > $dev_result_filename

  local num_lines=$(comm -23 $dev_result_filename $production_result_filename | wc -l)

  if [[ "$num_lines" == "0" ]]; then
    echo -e "\033[0;32mOK\033[0;0m"
  else
    echo "----------------------------------------------------------------------"
    echo -e "\033[0;31mThe following permissions are in DEV, but not PRODUCTION\033[0;0m"
    comm -23 $dev_result_filename $production_result_filename
  fi
}

# alias hpbxgui_assets="hpbxgui_dev && RAILS_ENV=jcarson_dev hpbxgui_bundle exec rake hpbxgui:themed_assets:generate && RAILS_ENV=jcarson_dev hpbxgui_bundle exec rake assets:precompile && touch tmp/restart.txt"

# alias hpbxgui_chat_recompile="hpbxgui_dev && rm -f public/assets/chat-*.js && hpbxgui_bundle exec rake assets:precompile && touch tmp/restart.txt"
function __hpbxgui_chat_syntax__ {
  local node_bin=$(which node)
  local grep_bin=$(which grep)

  for js in $(ls ./app/assets/javascripts/chat/*.js); do
    $node_bin $js 1>/dev/null 2>/dev/null

    if [[ "$?" != "0" ]]; then
      local node_result=$($node_bin $js 2>&1)
      echo "$node_result" | $grep_bin -q '^ReferenceError: \$ is not defined'
      if [[ "$?" != "0" ]]; then
        echo $js
      fi
    fi
  done
}
# alias hpbxgui_chat_syntax="hpbxgui_dev && __hpbxgui_chat_syntax__"

# alias hpbxgui_clear_assets="hpbxgui_dev && rm -f public/assets/application-*.js && rm -f public/assets/application-*.css && rm -f public/assets/jcarson-dev-*.js && rm -f public/assets/jcarson-dev-*.css && rm -f public/assets/chat-*.js && rm -f public/assets/chat-*.css && rm -f public/assets/dev-*.js && rm -f public/assets/dev-*.css"
# alias hpbxgui_bundle="LD_LIBRARY_PATH=\"${__rmagick_lib_path__}\" bundle"
# alias hpbxgui_bundle="bundle"
# alias hpbxgui_console="hpbxgui_dev && hpbxgui_bundle exec rails console -e jcarson_dev"
# alias hpbxgui_create_migration="hpbxgui_dev && RAILS_ENV=jcarson_dev hpbxgui_bundle exec rails generate migration"
# alias hpbxgui_db_dump="hpbxgui_dev && RAILS_ENV=jcarson_dev hpbxgui_bundle exec rake db:schema:dump"
# alias hpbxgui_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/hosted/hpbxgui"
# alias hpbxgui_log="hpbxgui_dev && tail -f ./log/jcarson_dev.log"
# alias hpbxgui_jlog="hpbxgui_dev && tail -f ./log/jcarson_dev.log | grep 'JCARSON'"
# alias hpbxgui_migrate="hpbxgui_dev && RAILS_ENV=jcarson_dev hpbxgui_bundle exec rake db:migrate"
# alias hpbxgui_migrate_status="hpbxgui_dev && RAILS_ENV=jcarson_dev hpbxgui_bundle exec rake db:migrate:status"
# alias hpbxgui_ngrok="__ngrok_shuffle__ hpbxgui && ngrok http https://jcarson-hpbxgui.monmouth.com --domain loving-bold-alpaca.ngrok-free.app"
# alias hpbxgui_permission_diff="hpbxgui_dev && __hpbxgui_permission_diff__"
# alias hpbxgui_rlog="hpbxgui_dev && tail -f ./log/jcarson_dev.log  | grep -A 1 -B 1 'Processing by'"
# alias hpbxgui_runner="hpbxgui_dev && hpbxgui_bundle exec rails runner -e jcarson_dev"
# alias hpbxgui_seed="ruby2 && indie_crm_ctl.sh -c restore_all -r mttpbx"
# alias hpbxgui_test_db_reset="hpbxgui_dev && RAILS_ENV=hpbxgui_test JC_DB=${__hpbxgui_test_db__} JC_USER=${__hpbxgui_test_user__} JC_PASS=${__hpbxgui_test_pass__} JC_SOCK=${__hpbxgui_test_socket__} hpbxgui_bundle exec rake hpbxgui:test:db:reset"
# alias hpbxgui_test_run="hpbxgui_dev && RAILS_ENV=hpbxgui_test JC_DB=${__hpbxgui_test_db__} JC_USER=${__hpbxgui_test_user__} JC_PASS=${__hpbxgui_test_pass__} JC_SOCK=${__hpbxgui_test_socket__} hpbxgui_bundle exec rake hpbxgui:test:run_no_controllers"
# alias hpbxgui_test_sia="__hpbxgui_test_sia__"

alias hpbxgui_assets="hpbxgui_bundle exec rake assets:precompile && touch tmp/restart.txt"
alias hpbxgui_bundle="hpbxgui_dev && RAILS_ENV=jcarson_dev bundle"
alias hpbxgui_console="hpbxgui_bundle exec rails console -e jcarson_dev"
alias hpbxgui_create_migration="hpbxgui_bundle exec rails generate migration"
alias hpbxgui_dev="ruby3 && cd ~/git_clones/hosted/hpbxgui"
alias hpbxgui_db_migrate_status="hpbxgui_bundle exec rake db:migrate:status"
alias hpbxgui_db_migrate="hpbxgui_bundle exec rake db:migrate"
alias hpbxgui_schema_dump="hpbxgui_bundle exec rake db:schema:dump"
