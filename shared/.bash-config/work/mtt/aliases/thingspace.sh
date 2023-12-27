alias thingspace_dev="ruby2 && cd /home/jcarson/git_clones/thingspace-api-ruby"
alias thingspace_test_run="thingspace_dev && THINGSPACE_API_RUBY_ENV=test bundle exec rake thingspace_api_ruby:test:run"
alias thingspace_sanity_check_run="thingspace_dev && script/console -c 'Thingspace::SanityCheck.run!'"
