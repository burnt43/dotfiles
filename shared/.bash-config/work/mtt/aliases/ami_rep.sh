alias ami_rep_dev="ruby2 && cd ~/git_clones/ami-replication && __echo_dev_name__ AmiRepDev"
alias ami_rep_run="ami_rep_dev && ./script/ami-replication.sh"
alias ami_rep_passive_sync_check="ami_rep_dev && ./script/ami-rep-cmd.sh --passive-sync-check --server-designated-as-backup=cl-hpbx2 --ignore-tenant_unknown-failures --ignore-warnings --ignore-secondary-virtual-server-feature-not-enabled-failures --debug"
