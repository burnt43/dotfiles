alias ari_dev="ruby3 && cd ~/git_clones/asterisk-ari/ && __echo_dev_name__ AriDev"
alias ari_test_run="ari_dev && RUBYOPT=-W0 GEM_HOME=/home/jcarson/.gems/asterisk-ari/ruby/3.3.0/ GEM_PATH='' rake asterisk_ari:test:run"
