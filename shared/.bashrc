#  _               _              
# | |             | |             
# | |__   __ _ ___| |__  _ __ ___ 
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__ 
# |_.__/ \__,_|___/_| |_|_|  \___|
#

case "$(hostname)" in
  burnt43*)
    base_path=~/.bash-config
    my_paths=(
      shell_prefix.sh
      binds.sh
      arch.sh
      functions.sh
      aliases.sh
      work/mtt/functions.sh
      work/mtt/aliases/ruby.sh
      work/mtt/aliases/agi_server.sh
      work/mtt/aliases/ami.sh
      work/mtt/aliases/ami_client.sh
      work/mtt/aliases/ami_message_capture.sh
      work/mtt/aliases/ami_rep.sh
      work/mtt/aliases/ami_socket.sh
      work/mtt/aliases/asterisk_ari.sh
      work/mtt/aliases/asterisk_cdr.sh
      work/mtt/aliases/asterisk_config.sh
      work/mtt/aliases/asterisk_database.sh
      work/mtt/aliases/asterisk_queue_ctl.sh
      work/mtt/aliases/auto_dialer.sh
      work/mtt/aliases/bootstrap_helper.sh
      work/mtt/aliases/call_blaster.sh
      work/mtt/aliases/call_recorder.sh
      work/mtt/aliases/cli_builder.sh
      work/mtt/aliases/cti.sh
      work/mtt/aliases/data_monitor.sh
      work/mtt/aliases/delayed_jobs.sh
      work/mtt/aliases/dns.sh
      work/mtt/aliases/engoncall.sh
      work/mtt/aliases/eqpt_gui.sh
      work/mtt/aliases/faye.sh
      work/mtt/aliases/flow_lang.sh
      work/mtt/aliases/hop.sh
      work/mtt/aliases/hop_client.sh
      work/mtt/aliases/hpbxgui.sh
      work/mtt/aliases/httpd.sh
      work/mtt/aliases/ibm_s2t_api.sh
      work/mtt/aliases/ibm_t2s_api.sh
      work/mtt/aliases/influxdb.sh
      work/mtt/aliases/liteorm.sh
      work/mtt/aliases/mobile_app.sh
      work/mtt/aliases/msteams.sh
      work/mtt/aliases/mtt_ai.sh
      work/mtt/aliases/mtt_crm.sh
      work/mtt/aliases/oni_ractor.sh
      work/mtt/aliases/openai_api.sh
      work/mtt/aliases/rails_env_loader.sh
      work/mtt/aliases/rec_mon.sh
      work/mtt/aliases/rma.sh
      work/mtt/aliases/rdm.sh
      work/mtt/aliases/ruby-ractor-utils.sh
      work/mtt/aliases/ruby-rtp.sh
      work/mtt/aliases/sip_utils.sh
      work/mtt/aliases/soft_phone.sh
      work/mtt/aliases/solr_mon.sh
      work/mtt/aliases/stir_shaken_server.sh
      work/mtt/aliases/system_upgrade.sh
      work/mtt/aliases/thingspace.sh
      work/mtt/aliases/xymon.sh
      work/mtt/aliases/xymon_reporter.sh
      work/mtt/aliases/generic.sh
      work/mtt/exports.sh
      exports.sh
      shell_welcome.sh
    )
    ;;
  fakebiz0*)
    base_path=~/.bash-config
    my_paths=(
      shell_prefix.sh
      binds.sh
      arch.sh
      functions.sh
      aliases.sh
      home/fakebiz0/aliases.sh
      exports.sh
      shell_welcome.sh
    )
    ;;
esac

for p in "${my_paths[@]}"; do
  file_to_source="${base_path}/${p}"

  [[ ! -e $file_to_source ]] && continue

  source $file_to_source
done
