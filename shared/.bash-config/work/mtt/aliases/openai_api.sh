alias openai_dev="ruby3 && cd ~/git_clones/openai-api"
alias openai_sanity_check="openai_dev && ./script/sanity_check.sh"
alias openai_test_run="openai_dev && bundle exec rake openai_api:test:run"
