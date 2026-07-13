alias agi_server_dev="ruby2 && cd ~/git_clones/agi-server && __echo_dev_name__ AgiServerDev"
alias agi_server_test_run="agi_server_dev && bundle exec rake agi_server:test:run"
alias agi_server_request="agi_server_dev && ruby ./script/agi_request.rb"
