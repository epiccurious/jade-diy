#!/bin/bash
set -e
clear

esp_dir="${HOME}/esp"
esp_idf_git_dir="${esp_dir}/esp-idf"
esp_idf_git_tag="v5.0.1"
jade_git_dir="${HOME}/jade"

device1="TTGO T-Display"
device2="M5Stack M5StickC PLUS"
device3="M5Stack Core Basic"
device4="M5Stack FIRE"

echo "------------------------------------------------------------"
echo "------------------------------------------------------------"
echo "---                                                      ---"
echo "---          Do-It-Yourself Jade Install Script          ---"
echo "---                Written by Epic Curious               ---"
echo "---                Twitter: @epic_curious                ---"
echo "---                                                      ---"
echo "------------------------------------------------------------"
echo "------------------------------------------------------------"
echo

case "$(uname -s)" in
    Linux*)
        machine="Linux"
        echo "Detected ${machine}."
        echo "Checking for sudo permission... "
        sudo echo -n
        echo -n "Checking for cmake, git, pip, and venv... "
        sudo apt-get -qq update
        sudo apt-get -qq install -y cmake git python3-pip python3-venv
        echo "ok."
        ;;
    Darwin*)
        machine="macOS"
        echo "Detected ${machine}."
        echo -n "Assuming you've already installed cmake... "
        echo "ok."
        ;;
    MINGW*)
        echo "Windows is not supported." && exit 0;;
    *) echo "Unsupported OS: $(uname -s)" && exit 0
esac

echo -n "Checking for the Espressif IoT Development Framework... "
if [ ! -f "${esp_idf_git_dir}"/export.sh ]
then
    echo -ne "\n  Downloading the framework... "
    [ -d "${esp_dir}" ] || mkdir "${esp_dir}"
    git clone --quiet https://github.com/espressif/esp-idf.git "${esp_idf_git_dir}"/
    cd "${esp_dir}"/esp-idf
    git checkout --quiet "${esp_idf_git_tag}"
    git submodule update --quiet --init --recursive
    echo "ok."
    echo -n "  Installing the framework... "
    ./install.sh esp32 1>/dev/null
fi
. "${esp_idf_git_dir}"/export.sh 1>/dev/null
echo "ok."

echo -n "Checking for the Blockstream Jade repository... "
if [ ! -d "${jade_git_dir}" ]
then
    echo -ne "\n  Downloading Jade... "
    git clone --quiet https://github.com/blockstream/jade.git "${jade_git_dir}"
    #git checkout $(git tag | grep -v miner | sort -V | tail -1)
fi
cd "${jade_git_dir}"
git submodule update --quiet --init --recursive
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

case "${machine}" in
    Linux*)
        while [ ! -c "${tty_device}" ]
        do
            echo -ne "\nConnect your $opt and PRESS ANY KEY TO CONTINUE... "
            read -rn1
            echo
        done
        sudo chmod o+rw "${tty_device}"
        ;;
    macOS*)
        echo -ne "\nConnect your $opt, click Allow on the popup, and PRESS ANY KEY TO CONTINUE... "
        read -rn1
        echo
        ;;
    MINGW*)
        echo "Windows is not supported." && exit 0;;
    *) echo "Unsupported OS: $(uname -s)" && exit 0
esac

echo -e "\nReady to install Jade on your ${opt}.\n(This process can take over 10 minutes.)"
echo -n "PRESS ANY KEY TO CONTINUE... "
read -rn1
echo

${flash_command}

echo -e "\nSUCCESS!\nJade is now installed on your ${opt}."
