alias ami_socket_console="ami_socket_dev && ./script/console"
alias ami_socket_dev="ruby2 && cd ~/git_clones/ami-socket && __echo_dev_name__ AmiSocketDev"
alias ami_socket_test_run="ami_socket_dev && bundle exec rake ami_socket:test:run"
alias ami_socket_sanity_check="ami_socket_dev && ruby ./script/sanity_check.rb"
