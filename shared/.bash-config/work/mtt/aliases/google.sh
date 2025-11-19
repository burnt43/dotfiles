alias google_ai_dev="ruby3 && cd /home/jcarson/git_clones/google-ai-api"
alias google_ai_sanity_check="google_ai_dev && ./script/sanity_check.sh"
alias google_ai_test_run="google_ai_dev && bundle exec rake google_ai_api:test:run"
alias play_google_pcm="play -t raw -r 24000 -e signed -b 16 -c 1"
