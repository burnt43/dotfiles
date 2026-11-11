alias data_monitor_dev="cd /home/jcarson/git_clones/data-monitor"
alias data_monitor_test_run="data_monitor_dev && DATA_MONITOR_ENV=test THINGSPACE_API_RUBY_ENV=test bundle exec rake data_monitor:test:run"
alias data_monitor_run="data_monitor_dev && XYMSRV=209.191.1.133 XYMON=/home/jcarson/xymon/bin/xymon DATA_MONITOR_ENV=development bundle exec ruby -I ./lib ./data_monitor.rb"
