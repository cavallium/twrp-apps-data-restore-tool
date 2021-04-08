#!/bin/bash -e

# The following script will restore apps 
# from a TWRP backup to an android phone.
# Root adb access must be available.

# 1. Extract all the data volumes in the TWRP backup
	# tar -xvf data.ext4.win000
	# tar -xvf data.ext4.win001 etc.
# 2. Turn the bash script into an executable 
	# chmod +x restore_android_packages.sh
# 3. Run script
	# ./restore_android_packages.

# The following resources were used in the creation of this script.
# https://www.semipol.de/2016/07/30/android-restoring-apps-from-twrp-backup.html
# https://itsfoss.com/fix-error-insufficient-permissions-device/

# Android user number (0, 10, 11, ...)
BACKUP_USER_NUMBER="$1"
# Android user number (0, 10, 11, ...)
USER_NUMBER="$2"
# TWRP extract location for data/data/
if [ "$USER_NUMBER" == "0" ]
	then
		localpackages="work/data/data/"
	else
		localpackages="work/data/user/${BACKUP_USER_NUMBER}/"
fi
# Android delivery destination
remotepackages="/data/user/${USER_NUMBER}/"

# filename of packages in data/data/ to restore
readarray -t packages < "work/packages_list_${BACKUP_USER_NUMBER}.txt"

if [ -z "$BACKUP_USER_NUMBER" ]
  then
    echo "Syntax: script.sh <old_user_id_number> <new_user_id_number>"
    exit 1
fi

if [ -z "$USER_NUMBER" ]
  then
    echo "Syntax: script.sh <old_user_id_number> <new_user_id_number>"
    exit 1
fi

printf "=========================================================\n"
printf "Killing ADB server\n"
#adb kill-server
printf "Starting ADB server with sudo\n"
#sudo adb start-server
printf "Starting ADB as root\n"
#adb root
adb shell su -c "mkdir -p /sdcard/.to_move"
printf "=========================================================\n"

for package in ${packages[*]}
do
  {
    printf "=========================================================\n"
    adb shell am start -a android.intent.action.VIEW -d market://details?id=$package
    #while [ -n "$(adb shell "dumpsys activity | grep top-activity | grep 'com.android.vending'")" ]; do
    # echo "wait..."
    # sleep 1
    #done
    echo "When you have the app installed, press volume UP to copy the data, press volume DOWN to skip"
    if [[ $(adb shell "getevent -l -v4 | grep -m1 --line-buffered KEY_VOLUME") == *"KEY_VOLUMEDOWN"* ]]; then
     echo "skipped $package"
    else
	    printf "Killing %s\n" $package
	    adb shell su -c "am force-stop --user $USER_NUMBER $package"
	    printf "Clearing %s\n" $package
	    adb shell su -c "pm clear --user $USER_NUMBER $package || true"
	    
	    userid=$(adb shell su -c "stat -c '%u' $remotepackages$package") || $(adb shell su -c "dumpsys package $package" | grep userId | cut -d "=" -f2- | tr -d [:alpha:] | head -n 1)
	    groupid=$(adb shell su -c "stat -c '%g' $remotepackages$package") || $(adb shell su -c "dumpsys package $package" | grep userId | cut -d "=" -f2- | tr -d [:alpha:] | head -n 1)
	    echo "App UserId=$userid"
	    echo "App GroupId=$groupid"
	    
	    printf "Compressing %s\n" $package
	    tar cfz .tmp_$package.tar.gz -C $localpackages $package/
	    printf "Copying %s\n" $package
	    adb shell su -c "chown -R shell:shell /sdcard/.to_move"
	    adb shell su -c "chmod -R 777 /sdcard/.to_move"
	    adb push .tmp_$package.tar.gz /sdcard/.to_move/.tmp_$package.tar.gz
	    rm .tmp_$package.tar.gz
	    printf "Extracting %s\n" $package
	    adb shell "su -c \"cd /sdcard/.to_move/ && tar xfzom /sdcard/.to_move/.tmp_$package.tar.gz -C $remotepackages && rm .tmp_$package.tar.gz\""
	#    printf "Restoring %s\n" $package
	#    adb shell su -c "mv /sdcard/.to_move/$package $remotepackages"
	    printf "Correcting package\n"
	    adb shell su -c "chown -R \"$userid:$groupid\" \"$remotepackages$package\""
	    adb shell su -c "restorecon -R \"$remotepackages$package\""
	    printf "Package restored on device\n"
	    sleep 1
    fi
	} || {
		echo "Error"
	}
done

