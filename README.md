TWRP apps data restore tool
===========================

This tool allows you to recover apps data from a TWRP-compatible backup

## Android requirements

- TWRP
- Magisk
- Magisk Manager
- ADB enabled

## Computer requirements

- Linux
- Bash installed
- adb (`sudo apt install android-tools-adb -y`)

## Usage

1. `./0_extract.sh <path-to-the-backup-directory>`
2. `./1_create_package_list.sh`
3. Remove the unwanted/system packages from work/packages_list_*<backup-user-id>*.txt
4. If you have multiple users on your phone, switch to the user you want to recover
5. `./2_twrp_manual_transfer.sh <backup-user-id> <current-phone-user-id>` (The default user id is 0,)
6. Follow what the console asks you.
	- If the app is not installed, install it, wait until it has completely finished, and then press volume UP.
	- If the app is already installed and you want to overwrite the data, just press volume UP.
	- If the app is already installed and you don't want to overwrite the data, just press volume DOWN.
	- If the play store tells you an error but you know that the app is already installed, press the volume UP button.
	- If the play store tells you an error and you don't have that app, skip to the next app using the volume DOWN button.
7. At the end restart the phone to fix permissions, if the app are crashing.

## ADB ".ab" backups
With .ab backups you must follow these extra steps before the others:
1. `adb backup --twrp`
2. Install the lastest openjdk version of your distro
3. `./ab_fix.sh <path-to-the-ab-file>`
3. follow the other steps

## License

The program is licensed with GPLv3 by Andrea Cavalli (https://cavallium.it)

twrpabx (https://github.com/prudy/twrpabx/tree/img_and_issue4)
