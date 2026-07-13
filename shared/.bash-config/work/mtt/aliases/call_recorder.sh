alias call_recorder_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/call_recorder"
alias call_recorder_dev="cd ~/git_clones/call_recorder && __echo_dev_name__ CallRecorderDev"
alias raudit_run="call_recorder_dev && RAUDIT_ENV=jcarson_dev ruby ./raudit/raudit.rb"
