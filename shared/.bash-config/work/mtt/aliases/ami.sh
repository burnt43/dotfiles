alias ami_dev="ruby2 && cd ~/git_clones/ami-fw-proxy && __echo_dev_name__ AmiDev"
alias ami_run="ami_dev && RAILS_ENV=development JDEV=1 ruby -I /home/jcarson/git_clones/hosted-burnt43/ami_fw_proxy/ ./secure_multiplexer_proxy.rb"
alias ami_sanity_checker="ami_dev && bundle exec ruby ./script/ami_sanity_checker.rb"
