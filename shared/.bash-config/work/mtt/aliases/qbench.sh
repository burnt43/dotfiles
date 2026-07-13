alias qbench_dev="ruby3 && cd ~/git_clones/quartz-bench && __echo_dev_name__ QbenchDev"
alias qbench_sanity_check="qbench_dev && ./script/sanity_check.sh"

qbench_data_prefixes=(rtp-delta time-to-wait-before-send-out-rtp-packet)
qbench_image_type=png
qbench_images_dir=/home/jcarson/.qbench/images
qbench_production_server=asterisk-pbx
qbench_production_server_data_dir=/home/asterisk/.qbench/data/time_series_benchmarker
qbench_staging_server=asterisk-nb-mg3
qbench_staging_server_data_dir=/home/asterisk/.qbench/data/time_series_benchmarker
qbench_local_timeseries_dir=/home/jcarson/.qbench/data/time_series_benchmarker

function __qbench_plot_data__ {
  local prefix="$1"
  local xlabel="$2"
  local xattrname="$3"
  local ylabel="$4"
  local yattrname="$5"
  local optional_title="$6"
  local optional_file="$7"
  local optional_feh="$8"
  local latest_file_with_prefix=$(ls -t ${qbench_local_timeseries_dir}/${prefix}* | head -1)

  if [[ "$optional_feh" == "1" ]]; then
    if [[ ! -z "$optional_title" && ! -z "$optional_file" ]]; then
      qbench_dev && \
      ./script/plot_data.sh \
      --datafile $latest_file_with_prefix \
      --title $optional_title \
      --xlabel $xlabel \
      --xattrname $xattrname \
      --ylabel $ylabel \
      --yattrname $yattrname \
      --writefile $optional_file \
      --feh
    elif [[ ! -z "$optional_title" ]]; then
      qbench_dev && \
      ./script/plot_data.sh \
      --datafile $latest_file_with_prefix \
      --title $optional_title \
      --xlabel $xlabel \
      --xattrname $xattrname \
      --ylabel $ylabel \
      --yattrname $yattrname \
      --writefile ./plot_data.${qbench_image_type} \
      --feh
    elif [[ ! -z "$optional_file" ]]; then
      qbench_dev && \
      ./script/plot_data.sh \
      --datafile $latest_file_with_prefix \
      --xlabel $xlabel \
      --xattrname $xattrname \
      --ylabel $ylabel \
      --yattrname $yattrname \
      --writefile $optional_file \
      --feh
    else
      qbench_dev && \
      ./script/plot_data.sh \
      --datafile $latest_file_with_prefix \
      --xlabel $xlabel \
      --xattrname $xattrname \
      --ylabel $ylabel \
      --yattrname $yattrname \
      --writefile ./plot_data.${qbench_image_type} \
      --feh
    fi
  else
    if [[ ! -z "$optional_title" && ! -z "$optional_file" ]]; then
      qbench_dev && \
      ./script/plot_data.sh \
      --datafile $latest_file_with_prefix \
      --title $optional_title \
      --xlabel $xlabel \
      --xattrname $xattrname \
      --ylabel $ylabel \
      --yattrname $yattrname \
      --writefile $optional_file
    elif [[ ! -z "$optional_title" ]]; then
      qbench_dev && \
      ./script/plot_data.sh \
      --datafile $latest_file_with_prefix \
      --title $optional_title \
      --xlabel $xlabel \
      --xattrname $xattrname \
      --ylabel $ylabel \
      --yattrname $yattrname \
      --writefile ./plot_data.${qbench_image_type}
    elif [[ ! -z "$optional_file" ]]; then
      qbench_dev && \
      ./script/plot_data.sh \
      --datafile $latest_file_with_prefix \
      --xlabel $xlabel \
      --xattrname $xattrname \
      --ylabel $ylabel \
      --yattrname $yattrname \
      --writefile $optional_file
    else
      qbench_dev && \
      ./script/plot_data.sh \
      --datafile $latest_file_with_prefix \
      --xlabel $xlabel \
      --xattrname $xattrname \
      --ylabel $ylabel \
      --yattrname $yattrname \
      --writefile ./plot_data.${qbench_image_type}
    fi
  fi

}
alias qbench_plot_rtp_delta="__qbench_plot_data__ rtp-delta Timestamp timestamp Delta value"
alias qbench_plot_rtp_sleep="__qbench_plot_data__ time-to-wait-before-send-out-rtp-packet Timestamp timestamp Duration value"

function __qbench_grab_latest_data__ {
  local my_server="$1"
  local my_dir="$2"

  for pref in "${qbench_data_prefixes[@]}"; do
    local latest_data=$(ssh ${my_server} "ls -t ${my_dir}/${pref}* | head -1")
    scp ${my_server}:${latest_data} $qbench_local_timeseries_dir/
  done
}
alias qbench_grab_latest_data_from_production="__qbench_grab_latest_data__ $qbench_production_server $qbench_production_server_data_dir"
alias qbench_grab_latest_data_from_staging="__qbench_grab_latest_data__ $qbench_staging_server $qbench_staging_server_data_dir"

function __qbench_create_graphs_from_latest_data_locally__ {
  local ai_endpoint="$1"
  local description="$2"

  for pref in "${qbench_data_prefixes[@]}"; do
    case "$pref" in
      rtp-delta)
        qbench_plot_rtp_delta "${ai_endpoint}_rtp_delta" "${qbench_images_dir}/${ai_endpoint}-rtp-delta_${description}.${qbench_image_type}" 0
        ;;
      time-to-wait-before-send-out-rtp-packet)
        qbench_plot_rtp_sleep "${ai_endpoint}_rtp_sleep" "${qbench_images_dir}/${ai_endpoint}-rtp-sleep_${description}.${qbench_image_type}" 0
        ;;
    esac
  done
}
alias qbench_create_graphs_from_latest_data_locally="__qbench_create_graphs_from_latest_data_locally__"
