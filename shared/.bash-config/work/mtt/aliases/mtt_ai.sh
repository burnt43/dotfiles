alias mtt_ai_agi_console="mtt_ai_dev && ./script/console.sh -t agi"
alias mtt_ai_agi_server="mtt_ai_dev && ./script/agi_server.sh"
alias mtt_ai_ari_console="mtt_ai_dev && ./script/console.sh -t ari"
alias mtt_ai_ari_server="mtt_ai_dev && ./script/ari_server.sh"
alias mtt_ai_dev="ruby3 && cd ~/git_clones/mtt-ai"
alias mtt_ai_console="mtt_ai_dev && ./script/console.sh"
alias mtt_ai_test_run="mtt_ai_dev && MTT_AI_ENV=test bundle exec rake mtt_ai:test:run"
alias mtt_ai_test_reset="mtt_ai_dev && MTT_AI_ENV=test bundle exec rake mtt_ai:test:db:reset"

function __gem_sanity_check_version_compare__ {
  local project_name=$1
  local gem_name=$2
  local project_version=$3
  local latest_gem_version=$4

  if [[ "$project_version" == "$latest_gem_version" ]]; then
    printf "%-30s %-30s %-10s %-10s \033[0;32mOK\033[0;0m\n" "$project_name" "$gem_name" "$project_version" "$latest_gem_version"
  else
    printf "%-30s %-30s %-10s %-10s \033[0;31mFAIL\033[0;0m\n" "$project_name" "$gem_name" "$project_version" "$latest_gem_version"
  fi
}

function __gem_sanity_check__ {
  # Gemspecs
  local openai_api_gemspec=/home/jcarson/git_clones/openai-api/openai-api.gemspec
  local openai_api_lite_gemspec=/home/jcarson/git_clones/openai-api/openai-api-lite.gemspec
  local mtt_ai_gemspec=/home/jcarson/git_clones/mtt-ai/mtt-ai.gemspec
  local version_control_gemspec=/home/jcarson/git_clones/active-record-version-control/active-record-version-control.gemspec

  # Gemfiles
  local hpbxgui_gemfile=/home/jcarson/git_clones/hosted/hpbxgui/Gemfile
  local mtt_ai_gemfile=/home/jcarson/git_clones/mtt-ai/Gemfile

  # Gem Names
  local openai_api_gem_name=openai-api
  local openai_api_lite_gem_name=openai-api-lite
  local mtt_ai_gem_name=mtt-ai
  local version_control_gem_name=active-record-version-control

  # Project Names
  local hpbxgui_project_name=hpbxgui
  local mtt_ai_project_name=mtt_ai

  # Latest Versions
  local latest_openai_api_version=$(grep "\.version" $openai_api_gemspec | cut -d= -f2 | sed "s/^\s*'//g" | sed "s/'.*$//g")
  local latest_openai_api_lite_version=$(grep "\.version" $openai_api_lite_gemspec | cut -d= -f2 | sed "s/^\s*'//g" | sed "s/'.*$//g")
  local latest_mtt_ai_version=$(grep "\.version" $mtt_ai_gemspec | cut -d= -f2 | sed "s/^\s*'//g" | sed "s/'.*$//g")
  local latest_version_control_version=$(grep "\.version" $version_control_gemspec | cut -d= -f2 | sed "s/^\s*'//g" | sed "s/'.*$//g")

  # Versions Used
  local openai_api_lite_version_used_in_hpbxgui=$(grep "^\s*gem '$openai_api_lite_gem_name" $hpbxgui_gemfile | awk '{print $3}' | sed "s/^'//g" | sed "s/'.*$//g")
  local mtt_ai_version_used_in_hpbxgui=$(grep "^\s*gem '$mtt_ai_gem_name" $hpbxgui_gemfile | awk '{print $3}' | sed "s/^'//g" | sed "s/'.*$//g")
  local version_control_version_used_in_hpbxgui=$(grep "^\s*gem '$version_control_gem_name" $hpbxgui_gemfile | awk '{print $3}' | sed "s/^'//g" | sed "s/'.*$//g")

  local openai_api_version_used_in_mtt_ai=$(grep "^\s*gem '$openai_api_gem_name" $mtt_ai_gemfile | awk '{print $3}' | sed "s/^'//g" | sed "s/'.*$//g")
  local version_control_version_used_in_mtt_ai=$(grep "^\s*gem '$version_control_gem_name" $mtt_ai_gemfile | awk '{print $3}' | sed "s/^'//g" | sed "s/'.*$//g")

  __gem_sanity_check_version_compare__ "$hpbxgui_project_name" "$openai_api_lite_gem_name" "$openai_api_lite_version_used_in_hpbxgui" "$latest_openai_api_lite_version"
  __gem_sanity_check_version_compare__ "$hpbxgui_project_name" "$mtt_ai_gem_name" "$mtt_ai_version_used_in_hpbxgui" "$latest_mtt_ai_version"
  __gem_sanity_check_version_compare__ "$hpbxgui_project_name" "$version_control_gem_name" "$version_control_version_used_in_hpbxgui" "$latest_version_control_version"

  __gem_sanity_check_version_compare__ "$mtt_ai_project_name" "$openai_api_gem_name" "$openai_api_version_used_in_mtt_ai" "$latest_openai_api_version"
  __gem_sanity_check_version_compare__ "$mtt_ai_project_name" "$version_control_gem_name" "$version_control_version_used_in_mtt_ai" "$latest_version_control_version"
}

alias mtt_ai_gem_sanity_check="__gem_sanity_check__"
