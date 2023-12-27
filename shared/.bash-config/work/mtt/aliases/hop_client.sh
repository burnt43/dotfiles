function __hop_client__ {
  local username="$1"

  if [[ -z "$username" ]]; then
    # Just find the first session_id in the database.
    local session_id=$(mysql hpbx_indie_crm --skip-column-names --batch -e "SELECT session_id FROM sessions LIMIT 1;")
  else
    # Execute some minimal ruby code to find the session_id from the given
    # username.
    local session_id=$(hop_dev &&
    GEM_HOME=/home/jcarson/.gems/operator-panel/ruby/2.6.0 \
    GEM_PATH="" \
    /usr/local/ruby/ruby-2.6.1/bin/ruby \
    -r active_record \
    -r active_record/session_store \
    -r action_controller \
    -e "h={}; h['development']=YAML.load(IO.read('./config/env_config.yml')).dig('development', 'database'); ActiveRecord::Base.configurations = h; ActiveRecord::Base.establish_connection(:development); puts ActiveRecord::SessionStore::Session.all.find {|x| x.data['current_username'] == '$username'}&.session_id" \
    2>/dev/null)
  fi

  if [[ -z "$session_id" ]]; then
    # Generate a random bullshit session_id if we couldn't find one.
    local session_id=$(cat /dev/urandom | tr -c -d 'a-z0-9' | fold -w 32 | head -1)
  fi

  # Connect to the hop server using the session_id we found/generated.
  cd ~/git_clones/hop_js_client
  node ./hop_js_client.js wss://jcarson-hop.monmouth.com:11081 $session_id 2>/dev/null
}

alias hop_client_dev="cd ~/git_clones/hop_js_client"
alias hop_client_run="__hop_client__"
