mobile_android_home=/home/jcarson/Android/Sdk
mobile_ld_library_path=/usr/lib/jvm/java-17-openjdk/lib
mobile_java_home=/usr/lib/jvm/java-17-openjdk
mobile_studio_jdk=/usr/lib/jvm/java-17-openjdk

alias ast="LD_LIBRARY_PATH=$mobile_ld_library_path STUDIO_JDK=$mobile_studio_jdk /home/jcarson/.android-studio/bin/studio.sh"
alias mobile_dev="ruby2 && cd /home/jcarson/git_clones/mobileapp"
alias mobile_prepare="mobile_dev && ANDROID_HOME=$mobile_android_home LD_LIBRARY_PATH=$mobile_ld_library_path JAVA_HOME=$mobile_java_home cordova prepare android"
alias mobile_build="mobile_dev && ANDROID_HOME=$mobile_android_home LD_LIBRARY_PATH=$mobile_ld_library_path JAVA_HOME=$mobile_java_home cordova build android"
alias mobile_run="mobile_dev && mobile_status && ANDROID_HOME=$mobile_android_home LD_LIBRARY_PATH=$mobile_ld_library_path JAVA_HOME=$mobile_java_home cordova run android"
alias mobile_install="mobile_dev && mobile_status && adb install /home/jcarson/git_clones/mobileapp/platforms/android/app/build/outputs/apk/debug/app-debug.apk"

function __mobile_status__ {
  local adb_bin=$(which adb)
  local sed_bin=$(which sed)

  [[ -z "$adb_bin" ]] && echo -e "[\033[0;31mERROR\033[0;0m] - cannot find adb program" && return 1

  local device_line=$($adb_bin devices | $sed_bin -n '2p')
  local device_status=$(echo "$device_line" | awk '{print $2}')

  case "$device_status" in
    device)
      echo -e "\033[0;32mOK\033[0;0m"
      return 0
      ;;
    *)
      echo -e "[\033[0;31mERROR\033[0;0m] - device not in a good state"
      echo "  Check The Following:"
      echo "    - Phone is in Developer Mode"
      echo "    - Phone has USB Debugging Enabled"
      echo "    - Phone has file transfer USB Preference"
      echo "  Steps On Pixel:"
      echo "    - Settings -> About Phone -> Tap on Build Number Until Dev Mode Enables"
      echo "    - Settings -> (Search for Developer Options) -> USB Debugging"
      echo "    - Settings -> Connected Devices -> USB -> File Transfer / Android Auto"
      return 1
      ;;
  esac
}
alias mobile_status="__mobile_status__"
