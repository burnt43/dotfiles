alias asterisk_queue_ctl_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/asterisk-queue-ctl"
alias asterisk_queue_ctl_dev="ruby2 && cd /home/jcarson/git_clones/asterisk-queue-ctl"
alias asterisk_queue_ctl_test_run="asterisk_queue_ctl_dev && ASTERISK_QUEUE_CTL_ENV=test bundle exec rake asterisk_queue_ctl:test:run"
