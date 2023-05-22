#!/bin/bash
set -e
clear

echo "------------------------------------------------------------"
echo "------------------------------------------------------------"
echo "---                                                      ---"
echo "---          Jade Do-It-Yourself Install Script          ---"
echo "---                Written by Epic Curious               ---"
echo "---                Twitter: @epic_curious                ---"
echo "---                                                      ---"
echo "------------------------------------------------------------"
echo "------------------------------------------------------------"
echo

echo "Checking for sudo permission... "
sudo echo -n

echo -n "Checking for cmake, git, pip, and venv... "
sudo apt-get -qq update
sudo apt-get -qq install -y cmake git python3-pip python3-venv
echo "ok."

esp_git_dir="${HOME}/esp"
jade_git_dir="${HOME}/jade"
device1="TTGO T-Display"
device2="M5Stack M5StickC PLUS"
device3="M5Stack Core Basic"
device4="M5Stack FIRE"

echo -n "Checking for Espressif IoT Development Framework... "
if [ ! -f "${esp_git_dir}"/esp-idf/export.sh ]
then
    echo -ne "\n  Downloading the framework... "
    [ -d "${esp_git_dir}" ] || mkdir "${esp_git_dir}"
    git clone --quiet --recursive https://github.com/espressif/esp-idf.git "${esp_git_dir}"/esp-idf/
    cd "${esp_git_dir}"/esp-idf
    git checkout v5.0.1 &>/dev/null
    echo "ok."
    echo -n "  Installing the framework... "
    ./install.sh esp32
fi
. "${esp_git_dir}"/esp-idf/export.sh 1>/dev/null
echo "ok."

echo -n "Checking for the Blockstream Jade repository... "
if [ ! -d "${jade_git_dir}" ]
then
    echo -ne "\n  Downloading the repo... "
    git clone --quiet --recursive https://github.com/blockstream/jade "${jade_git_dir}"
fi
cd "${jade_git_dir}"
echo "ok."

echo -e "\nWhich device do you want to flash?"
PS3='Please enter the number for your device or QUIT: '
options=("${device1}" "${device2}" "${device3}" "${device4}" "QUIT")
select opt in "${options[@]}"
do
    case $opt in
        "$device1")
            tty_device="/dev/ttyACM0"
            flash_command="idf.py flash"
            cp configs/sdkconfig_display_ttgo_tdisplay.defaults sdkconfig.defaults
            break
            ;;
        "$device2")
            tty_device="/dev/ttyUSB0"
            flash_command="idf.py -b 115200 flash"
            cp configs/sdkconfig_display_m5stickcplus.defaults sdkconfig.defaults
            break
            ;;
        "$device3")
            tty_device="/dev/ttyACM0"
            flash_command="idf.py flash"
            cp configs/sdkconfig_display_m5blackgray.defaults sdkconfig.defaults
            break
            ;;
        "$device4")
            tty_device="/dev/ttyACM0"
            flash_command="idf.py flash"
            cp configs/sdkconfig_display_m5fire.defaults sdkconfig.defaults
            break
            ;;
        "QUIT")
            echo "You chose to quit."
            exit 0
            ;;
        *) echo "You entered ${REPLY}, which is invalid."
    esac
done

[ -f sdkconfig ] && rm sdkconfig
sed -i.bak '/CONFIG_DEBUG_MODE/d' ./sdkconfig.defaults
sed -i.bak '1s/^/CONFIG_LOG_DEFUALT_LEVEL_NONE=y\n/' sdkconfig.defaults

while [ ! -c ${tty_device} ]
do
    echo -ne "\nConnect your $opt then PRESS ANY KEY TO CONTINUE... "
    read -rn1
    echo
done

echo -E "Ready to install Jade on your ${opt}."
echo "(This process can take over 10 minutes.)"
echo -n "PRESS ANY KEY TO CONTINUE... "
read -rn1
echo

sudo chmod o+rw ${tty_device}
${flash_command}

echo -e "\nSUCCESS!\nJade is now installed on your ${opt}."
