dns_test_run
gits
git checkout -b update-dns-scripts-for-current-use-case
gits
git add -A
gits
git commit -m "small update. also removed pacemaker script tests. i don't think those are necessary and are brittle. we only need to test the generic dns_record_changer.sh script."
gfp
gits
./dns_record_changer.sh -h
ruby_file_text Functions
ruby_file_text GlobalVars
ruby_file_text Args
ruby_file_text Validate
ruby_file_text Defaults
ruby_file_text HostBasedVars
ruby_file_text PrintVars
ls -l dev/
ls -l dev/assets/
ls -l dev/assets/alt-
ls -l dev/assets/alt-dns1-like-dns.db
ruby_file_text LocalBasedVars
ruby_file_text RemoteBasedVars
./dns_record_changer.sh -h
./script/change_server_records.sh 
./script/change_server_records.sh -d rdbk
./script/change_server_records.sh -d rdbk -t app
./script/change_server_records.sh -d rdbk -t app -v
./script/change_server_records.sh -h
./script/change_server_records.sh -d rdbk -t app -v -f
./script/change_server_records.sh -d rdbk -t app -v -f
./dns_record_changer.sh -
./script/change_server_records.sh -d rdbk -t app -v
gits
git diff dev/assets/alt-dns1-like-dns.db
git checkout dev/assets/alt-dns1-like-dns.db
gits
git add -A
gits
git commit -m 'more changes'
git push
./script/change_server_records.sh -d rdbk -t app -v
./script/change_server_records.sh -d rdbk -t app -v
./script/change_server_records.sh -d rdbk -t app -v
gits
git diff dev/assets/alt-dns1-like-dns.db
./dns_record_changer.sh -h
./script/initd/activate_dns-rdbk-app.sh start
./script/initd/activate_dns-rdbk-app.sh start
gits
git diff dev/assets/alt-dns1-like-dns.db
git checkout dev/assets/alt-dns1-like-dns.db
gits
gits
git add dev/assets/alt-dns1-like-dns.db
gits
git commit -m 'make dev file look like how production is now.'
git push
./script/initd/activate_dns-rdbk-app.sh start
git diff /home/jcarson/git_clones/dns-record-changer/dev/assets/alt-dns1-like-dns.db
ping hosted
gits
git checkout dev/assets/alt-dns1-like-dns.db
./script/initd/activate_dns-rdbk-app.sh start
./script/initd/activate_dns-rdbk-app.sh start
git diff /home/jcarson/git_clones/dns-record-changer/dev/assets/alt-dns1-like-dns.db
gits
git checkout dev/assets/alt-dns1-like-dns.db
./script/initd/activate_dns-rdbk-app.sh start
git diff /home/jcarson/git_clones/dns-record-changer/dev/assets/alt-dns1-like-dns.db
./dns_record_changer.sh -h
ssh hosted
./script/initd/activate_dns-rdbk-app.sh status
echo $?
./script/initd/activate_dns-nwrk-app.sh status
echo $?
./script/initd/activate_dns-nwrk-app.sh status
dig hosted.monmouth.com +short
which difg
which dig
dig hosted.monmouth.com +short
./script/initd/activate_dns-nwrk-app.sh status
./script/initd/activate_dns-nwrk-app.sh status
./script/initd/activate_dns-nwrk-app.sh status
./script/initd/activate_dns-nwrk-app.sh status
./script/initd/activate_dns-nwrk-app.sh status
./script/initd/activate_dns-nwrk-app.sh status
./script/initd/activate_dns-nwrk-app.sh status
echo $?
echo $?
./script/initd/activate_dns-nwrk-app.sh status
./script/initd/activate_dns-nwrk-app.sh status
./script/initd/activate_dns-rdbk-app.sh status
echo $?
gits
git checkout dev/assets/alt-dns1-like-dns.db
script/initd/activate_dns-nwrk-db.sh start
git diff /home/jcarson/git_clones/dns-record-changer/dev/assets/alt-dns1-like-dns.db
script/initd/activate_dns-rdbk-db.sh start
git diff /home/jcarson/git_clones/dns-record-changer/dev/assets/alt-dns1-like-dns.db
script/initd/activate_dns-nwrk-db.sh start
git diff /home/jcarson/git_clones/dns-record-changer/dev/assets/alt-dns1-like-dns.db
ls -l script/
rm script/change_server_records.sh 
gits
git add -A
gits
git commit -m 'remove the change_server_records.sh script. it was a middle man that was supposed to simplify things, but it made things more complicated. the initd scripts can just call dns_record_changer.sh directly and its a lot more to the point.'
git push
ping vhpbx1
ping nk-hpbx2
ping hpbx2
./dns_record_changer.sh -h
ls -l dev/assets/
gits
gits
git add -A
gits
git commit -m 'update'
git push
gits
cat .gitignore 
gits
ruby_file_text App
ruby_file_text app
ruby_file_text db
ruby_file_text hpbx
ruby_file_text bin
ruby_file_text function
gits
git add -A
gits
git commit -m 'changes'
git push
gits
ls -l
./script/initd/activate_dns-rdbk-hpbx2.sh start
gits
git diff dev/assets/hosted-like-dns.db.template
git diff dev/assets/hosted-like-dns.db
./script/initd/activate_dns-nwrk-hpbx2.sh start
gits
git diff dev/assets/hosted-like-dns.db.template
git diff dev/assets/hosted-like-dns.db
gits
git add -A
gits
git commit -m 'changes'
git push
ls -l script/
rm script/change_tenant_records.sh 
gits
git add -A
gits
git commit -m 'remove dumb middle man script'
git push
cd script/initd/
ls -l
mv activate_dns-nwrk-hpbx2.sh activate_dns-nwrk-vhpbx1.sh
mv activate_dns-rdbk-hpbx2.sh activate_dns-rdbk-vhpbx1.sh
ls -l
gits
cd ../
cd ../
ls -l
gits
git add -A
gits
git commit -m 'small changes'
git push
./script/initd/activate_dns-rdbk-vhpbx1.sh start
gits
git diff dev/assets/hosted-like-dns.db
git diff dev/assets/hosted-like-dns.db.template
gits
gits
git add -A
gits
git commit -m 'changes'
git push
gsm
git checkout -b support-changing-hpbx-dns
gits
ls -l
ls -l test/
ls -l test/assets/
ls -l test/assets/perm/
ls -l test/assets/perm/
vim test/assets/perm/hpbx-hosted-like-dns.db
vim test/assets/perm/hpbx-hosted-prov-like-dns.db
vim test/assets/perm/hpbx-hosted-prov-like-dns.db
gits
git add -A
gits
git commit -m 'add files from production so I can use them in the test env'
gfp
ruby_file_text HpbxLike
dns_test_run
dns_test_run
ls -l
ls -l lib/
ls -l test/
ls -l test/assets/
ls -l test/assets/perm/
dns_test_run
gits
git add -A
gits
git commit -m "support new files to test in the test env"
git push
dns_test_run
dns_test_run
dns_test_run
dns_test_run
dns_test_run
dns_test_run
gits
git add -A
gits
git commit -m "add test for changing hosted records on hpbx servers"
git push
git push
dns_test_run
dns_test_run
dns_test_run
dns_test_run
gits
git add -A
gits
gits
git add -A
git commit -m 'add test for files on hpbx servers'
git push
dns_test_run
ping hpbx0
ping hpbx1
ping hpbx2
ping hpbx3
ping hpbx4
ping hpbx5
ping hpbx6
ping nk-hpbx2
ping nk-hpbx0
./dns_record_changer.sh -h
./script/initd/activate_dns-nwrk-app.sh start
./script/initd/activate_dns-nwrk-app.sh start
./script/initd/activate_dns-nwrk-app.sh start
./script/initd/activate_dns-nwrk-app.sh start
gits
git add -A
gits
git commit -m 'add some print out'
git push
gits
git add -A
gits
git commit -m 'update scripts'
git push
gits
gits
git add -A
gits
git commit -m 'todo reminder'
git push
gsm
gits
git checkout -b fixes-to-initd-scripts
gits
git add -A
gits
git commit -m "fix missing backslashes and fix wrong source and dest ips"
git push
gfp
gsm
gsm
git checkout -b handle-trailing-whitespace
gits
git diff
dns_test_run
gits
git diff
gits
git add -A
gits
git commit -m "hanlde trailing whitespace"
gfp
gsm
git checkout -b more-changes
gits
git add -A
gits
git commit -m "change colors"
gfp
dns_test_run
gits
git add -A
gits
git commit -m 'conditionally reload based on what the output file it'
git push
gsm
exit
hpbxgui_dev
mysql hpbxgui_jcarson_dev
exit
hpbxgui_dev
gsm
git checkout -b fix-queue-reload-script
grep -R "\.queue_command" ./
grep -R "\.queue_command" ./ | grep -v 'legacy'
irb
hpbxgui_console
./script/queue_asterisk_reload.rb 
ls -l /usr/local/bin/rub
ls -l /usr/local/bin/ruby
sudo ln -s /usr/local/bin/ruby $(which ruby)
sudo ln -s $(which ruby) /usr/local/bin/ruby
./script/queue_asterisk_reload.rb 
./script/queue_asterisk_reload.rb  
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
ls -l config/database.yml 
./script/queue_asterisk_reload.rb --name mttpbx
which gem
gem list
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
ls -l app/models/server
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
ls -l /home/jcarson/git_clones/hosted/hpbxgui/app/models/server/virtual_server.rb
ls -l /home/jcarson/git_clones/hosted/hpbxgui/app
ls -l /home/jcarson/git_clones/hosted/hpbxgui/app/models
ls -l /home/jcarson/git_clones/hosted/hpbxgui/app/models/server
ls -l /home/jcarson/git_clones/hosted/hpbxgui/app/models/server/can_perform_asterisk_reloads.rb
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
find ./ -type f -name '*global*'
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
ls -l app/models/
grep "class.*VirtualServer" app/models/*.rb
grep "class.*VirtualServer" app/models/*.rb | cut -d: -f1
grep "class.*VirtualServer" app/models/*.rb | cut -d: -f1 | sort | uniq
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx
./script/queue_asterisk_reload.rb --name mttpbx --conference
./script/queue_asterisk_reload.rb --name mttpbx --conference
grep -R "class.*SipConf" ./app/models/
./script/queue_asterisk_reload.rb --name mttpbx --conference
./script/queue_asterisk_reload.rb --name mttpbx --conference
find ./app -type f -name '*recon*'
./script/queue_asterisk_reload.rb --name mttpbx --conference
find ./app -type f -name '*move*'
./script/queue_asterisk_reload.rb --name mttpbx --conference
./script/queue_asterisk_reload.rb --name mttpbx --conference
./script/queue_asterisk_reload.rb --name mttpbx --conference
./script/queue_asterisk_reload.rb --name mttpbx --conference
./script/queue_asterisk_reload.rb --name mttpbx --conference
./script/queue_asterisk_reload.rb --name mttpbx --conference
./script/queue_asterisk_reload.rb --name mttpbx --conference
./script/queue_asterisk_reload.rb --name mttpbx --conference
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --conference
mysql -u hpbxgui -peasypeasy2 -h nk-app0
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --conference
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --dialplan
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --dialplan
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --features
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --feature
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --features
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --moh
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --queue
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --sip
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --voicemail
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --voicemail
gits
git add -A
gits
git commit -m "changes for the queue script"
gfp
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --voicemail
gits
RAILS_ENV=jcarson_dev ./script/queue_asterisk_reload.rb --name mttpbx --voicemail
gits
gits
gsm
gits
gits
gsm
git checkout -b voicemail-confinate-fix
hpbxgui_test_run
hpbxgui_test_run
gits
git add -A
gits
git commit -m 'quick reorg of extenable'
git push
gfp
grep -R "should_confinate" ./app
grep -R "should_confinate" ./app
hpbxgui_test_run
gits
git add -A
gits
git commit -m 'add basis of conditionally confinating'
git push
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
gits
gits
git add -A
gits
git commit -m 'start changing tests to be able to test this new feature'
git push
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
gits
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
grep -R "TenantEnv" ./hpbxgui_test/
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
gits
git add -A
gits
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
gits
git add -A
gits
git commit -m 'test currently fails intentionally until I writ ethe feature'
git push
hpbxgui_console
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
hpbxgui_test_run TEST="hpbxgui_test/tests/models/voicemail_test.rb"
hpbxgui_console
exit
mysql hpbxgui_jcarson_dev
exit
source ~/.bashrc 
ruby2
sudo su asterisk
ssh hosted
exit
ssh hosted
ssh pbx
exit
~/.fehbg
~/.fehbg
~/.fehbg
~/.fehbg
~/.fehbg
~/.fehbg
exit
~/.fehbg
~/.fehbg
~/.fehbg
~/.fehbg
~/.fehbg
~/.fehbg
~/.fehbg
~/.fehbg
exit
ssh pbx
exit
~/.fehbg
~/.fehbg
~/.fehbg
~/.fehbg
exit
ssh app0
exit
~/.fehbg
exit]
exit
telnet pl-2820-1
exit
ssh mtt3
exit
ssh vhpbx0
ssh hosted
exit
ssh mcm.sip.monmouth.com
exit
cd $(work.sh)
scp -l 10000 hpbx1:/home/jcarson/poop.cap ./
scp -l 10000 hpbx1:/home/jcarson/poop2.cap ./
exit
echo "4158423095"
exit
ssh hpbx1
exit
