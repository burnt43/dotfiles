alias sss_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/stir-shaken-server"
alias sss_dev="ruby2 && cd ~/git_clones/stir-shaken-server"
alias sss_run="sss_dev && SSS_ENV=jcarson_dev bundle exec ruby -I./lib ./stir_shaken_server.rb"
alias sss_test_run="sss_dev && SSS_ENV=test bundle exec rake sss:test:run"
