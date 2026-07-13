alias openai_dev="ruby3 && cd ~/git_clones/openai-api && __echo_dev_name__ OpenaiDev"
alias openai_sanity_check="openai_dev && ./script/sanity_check.sh"
alias openai_test_run="openai_dev && RUBYOPT=-W0 GEM_HOME=/home/jcarson/.gems/openai-api/ruby/3.3.0 GEM_PATH='' rake openai_api:test:run"
alias openai_post_beta_cq="find lib/api/v1/realtime/messages/inbound -type f | xargs -I bipbop sh -c \"echo -n 'bipbop -- ' && sed -n '2p' bipbop\" | grep -v \"POST_BETA_CQ\""

