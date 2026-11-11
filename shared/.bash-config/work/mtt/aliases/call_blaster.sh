alias call_blaster_dev="ruby2 && cd ~/git_clones/call_blaster"
alias call_blaster_run="call_blaster_dev && bundle exec ruby ./call_blaster_server.rb"
alias call_blaster_test_run="call_blaster_dev && CALL_BLASTER_ENV=test bundle exec rake call_blaster:test:run"
