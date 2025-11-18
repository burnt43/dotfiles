# Clear out the PATH
export PATH=""

# List of directories to add to the path in ascending order of priority.
my_paths=(
  /usr/bin/core_perl
  /usr/bin/vendor_perl
  /usr/bin/site_perl
  /usr/bin
  /usr/local/bin
  /usr/local/sbin
  /usr/local/ruby/ruby-3.3.1/bin
  /usr/local/mysql/mysql-5.7.21/bin/
  /usr/local/openssh/openssh-9.7p1/bin/
  /usr/local/python/python-3.13.7/bin/
  /home/jcarson/.npm-packages/bin
  /home/jcarson/.gems/eqpt-gui/ruby/3.1.0/gems/passenger-6.0.12/bin
  /home/jcarson/git_clones/work-scripts/personal
  /home/jcarson/git_clones/work-scripts/mtt/development
  /home/jcarson/Android/Sdk/platform-tools
  /home/jcarson/.android-studio/bin
)

# Iterate and add to the PATH.
for p in "${my_paths[@]}"; do
  [[ ! -e "$p" ]] && continue 

  if [[ -z "$(echo $PATH)" ]]; then
    export PATH="$p"
  else
    export PATH="${p}:$PATH"
  fi
done

export CVSROOT=:pserver:anonymous@cvs:/var/lib/cvs

# golang
export GOPATH=$HOME/go

# JRE 8
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/java-8-openjdk/jre/lib/amd64/:/usr/lib/jvm/java-8-openjdk/jre/lib/amd64/server

# JRE 10
# export JAVA_HOME=/usr/lib/jvm/java-10-openjdk
