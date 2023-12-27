__rmagick_lib_path__=/usr/local/ImageMagick/6.9.12-34/lib
__hpbxgui_test_db__=hpbxgui_test
__hpbxgui_test_user__=hpbxgui_tester
__hpbxgui_test_pass__=LfG*b95A8ehEQsr7
__hpbxgui_test_socket__=/usr/local/mysql/mysql-5.7.21/data/mysql.sock 

alias hpbxgui_bundle="LD_LIBRARY_PATH=\"${__rmagick_lib_path__}\" bundle"
alias hpbxgui_console="hpbxgui_dev && hpbxgui_bundle exec rails console -e jcarson_dev"
alias hpbxgui_create_migration="hpbxgui_dev && RAILS_ENV=jcarson_dev hpbxgui_bundle exec rails generate migration"
alias hpbxgui_db_dump="hpbxgui_dev && RAILS_ENV=jcarson_dev hpbxgui_bundle exec rake db:schema:dump"
alias hpbxgui_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/hosted/hpbxgui"
alias hpbxgui_dev="ruby2 && cd ~/git_clones/hosted/hpbxgui"
alias hpbxgui_log="hpbxgui_dev && tail -f ./log/jcarson_dev.log"
alias hpbxgui_jlog="hpbxgui_dev && tail -f ./log/jcarson_dev.log | grep 'JCARSON'"
alias hpbxgui_migrate="hpbxgui_dev && RAILS_ENV=jcarson_dev hpbxgui_bundle exec rake db:migrate"
alias hpbxgui_migrate_status="hpbxgui_dev && RAILS_ENV=jcarson_dev hpbxgui_bundle exec rake db:migrate:status"
alias hpbxgui_ngrok="__ngrok_shuffle__ hpbxgui && ngrok http https://jcarson-hpbxgui.monmouth.com --domain loving-bold-alpaca.ngrok-free.app"
alias hpbxgui_rlog="hpbxgui_dev && tail -f ./log/jcarson_dev.log  | grep -A 1 -B 1 'Processing by'"
alias hpbxgui_runner="hpbxgui_dev && hpbxgui_bundle exec rails runner -e jcarson_dev"
alias hpbxgui_seed="ruby2 && indie_crm_ctl.sh -c restore_all -r mttpbx"
alias hpbxgui_test_db_reset="hpbxgui_dev && RAILS_ENV=hpbxgui_test JC_DB=${__hpbxgui_test_db__} JC_USER=${__hpbxgui_test_user__} JC_PASS=${__hpbxgui_test_pass__} JC_SOCK=${__hpbxgui_test_socket__} hpbxgui_bundle exec rake hpbxgui:test:db:reset"
alias hpbxgui_test_run="hpbxgui_dev && RAILS_ENV=hpbxgui_test JC_DB=${__hpbxgui_test_db__} JC_USER=${__hpbxgui_test_user__} JC_PASS=${__hpbxgui_test_pass__} JC_SOCK=${__hpbxgui_test_socket__} hpbxgui_bundle exec rake hpbxgui:test:run_no_controllers"
