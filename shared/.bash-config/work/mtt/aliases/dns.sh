alias dns_dev="ruby2 && cd ~/git_clones/dns-record-changer/"
alias dns_test_run="dns_dev && DNS_ENV=test bundle exec rake dns_record_changer:test:run"
alias dns_dev_reset="ruby2 && bundle exec rake dns_record_changer:dev:assets:reset"
