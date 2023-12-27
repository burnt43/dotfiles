alias hop_deploy="ruby2 && __cap_deploy__ asterisk /home/asterisk/git_clones/operator-panel"
alias hop_dev="ruby2 && cd ~/git_clones/operator-panel"
alias hop_run="hop_dev && HOP_ENV=jcarson_dev bundle exec ruby ./hop.rb"
alias hop_run_ruby_3="hop_dev && HOP_ENV=development /usr/local/ruby/ruby-3.0.2/bin/bundle exec /usr/local/ruby/ruby-3.0.2/bin/ruby ./hop.rb"
