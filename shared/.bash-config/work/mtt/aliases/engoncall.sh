alias engoncall_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/engoncall"
alias engoncall_dev="ruby2 && cd ~/git_clones/engoncall && __echo_dev_name__ EngoncallDev"
alias engoncall_test_run="engoncall_dev && ENGONCALL_ENV=test bundle exec rake engoncall:test:run"
