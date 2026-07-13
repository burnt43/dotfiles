alias ami_client_dev="cd ~/git_clones/asterisk-manager-interface-client && __echo_dev_name__ AmiClientDev"
alias ami_client_sample_run="ami_client_dev && bundle exec ruby -I~/git_clones/asterisk-manager-interface-client/lib ./sanity_checker.rb"
alias ami_client_test_run="ami_client_dev && bundle exec rake ami_client:test:run"
