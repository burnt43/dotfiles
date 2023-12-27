alias eqpt_gui_assets="eqpt_gui_dev && RAILS_ENV=jcarson_dev ./bin/dev"
alias eqpt_gui_billing_link="eqpt_gui_dev && RAILS_ENV=jcarson_dev bundle exec rake billing:sync:addresses"
alias eqpt_gui_console="eqpt_gui_dev && bundle exec rails console -e jcarson_dev"
alias eqpt_gui_debug_server="eqpt_gui_dev && ./bin/rails server -e jcarson_dev -b 127.0.0.1 -u puma"
alias eqpt_gui_deploy="ruby3 && __cap_deploy__ orderapp /home/orderapp/git_clones/eqpt-gui"
alias eqpt_gui_delayed="eqpt_gui_dev && RAILS_ENV=jcarson_dev bin/delayed_job --exit-on-complete run"
alias eqpt_gui_delayed_view="eqpt_gui_dev && mysql eqpt_gui_jcarson_dev --batch --skip-column-names -e \"SELECT handler FROM delayed_jobs;\" | /home/jcarson/git_clones/work-scripts/mtt/development/format_delayed_job.rb"
alias eqpt_gui_dev="ruby3 && cd /home/jcarson/git_clones/eqpt-gui"
alias eqpt_gui_db="eqpt_gui_dev && mysql eqpt_gui_jcarson_dev"

function __eqpt_gui_grep__ {
  local search_term="$1"

  grep -R "$search_term" ./config ./lib ./test $(find ./app -mindepth 1 -maxdepth 1 -type d \! -name javascript \! -name assets)
}
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
