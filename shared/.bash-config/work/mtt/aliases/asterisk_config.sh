alias asterisk_config_dev="ruby2 && cd ~/git_clones/asterisk-config"
alias asterisk_config_sample_run="asterisk_config_dev && bundle exec ruby -I./lib ./sanity_checker.rb"
alias asterisk_config_test_run="asterisk_config_dev && bundle exec rake asterisk_config:test:run"
