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
        echo -n "Checking for cmake... "
        if ! command -v cmake &>/dev/null; then
            if [ ! -d /Applications/CMake.app ]; then
                #read -srk "?  CMake is not found in your Applications directory.\n  PRESS ANY KEY to download CMake... " && echo
                #cmake_macos_url="https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4-macos-universal.tar.gz"
                #cmake_macos_tarball="${HOME}"/$(basename "${cmake_macos_url}")
                #cmake_macos_extract_dir="${HOME}/$(basename "${cmake_macos_url}" .tar.gz)"
                #wget -P "${HOME}" "${cmake_macos_url}"
                #tar -xf "${cmake_macos_tarball}" -C "${HOME}/"
                #cp -r "${cmake_macos_extract_dir}"/CMake.app/ /Applications/CMake.app/
                cmake_macos_url="https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4-macos-universal.dmg"
                cmake_macos_dmg="$(basename ${cmake_macos_url})"
                cmake_macos_volume="/Volumes/$(basename ${cmake_macos_url} .dmg)"
                echo -ne "\n  Downloading cmake... "
                #wget --quiet -P "${HOME}" "${cmake_macos_url}"
                wget --quiet -P "${HOME}/Downloads" "${cmake_macos_url}"
                echo "ok."

                echo "************************************************************"
                echo "ERROR: Automatic installation of CMake is not supported yet."
                echo "Please manually install \"${cmake_macos_dmg}\"."
                echo "Please open the file from your Downloads folder."
                echo "************************************************************"
                echo
                read -srk "?PRESS ANY KEY TO EXIT... " && echo
                exit 1
                
                #echo -n "  Installing cmake..."
                #hdiutil attach -quiet -nobrowse "${HOME}"/"${cmake_macos_dmg}"
                #cp -r ${cmake_macos_volume}/CMake.app/ /Applications/CMake.app/
                #hdiutil detach -quiet ${cmake_macos_volume}
                #rm "${HOME}"/"${cmake_macos_dmg}"
                #echo "ok."
            fi
            PATH="/Applications/CMake.app/Contents/bin${PATH:+:${PATH}}"
        fi
        echo "ok."
        ;;
    MINGW*)
        echo "Windows is not supported. Please run in WSL (Windows Subsystem for Linux)." && exit 0;;
    *) echo "Unsupported OS: $(uname -s)" && exit 0
esac

echo -n "Checking for the Espressif IoT Development Framework... "
if [ ! -f "${esp_idf_git_dir}"/export.sh ]; then
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
if [ ! -d "${jade_git_dir}" ]; then
    echo -ne "\n  Downloading Jade... "
    git clone --quiet https://github.com/blockstream/jade.git "${jade_git_dir}"
    cd "${jade_git_dir}"
    git checkout --quiet $(git tag | grep -v miner | sort -V | tail -1)
    git submodule update --quiet --init --recursive
fi
cd "${jade_git_dir}"
jade_version="$(git describe --tags)"
echo "ok."

echo -e "\nWhich device do you want to flash?"
PS3='Please enter the number for your device or QUIT: '
options=("${device1}" "${device2}" "${device3}" "${device4}" "QUIT")
select choice in "${options[@]}"
do
    case "${choice}" in
        "${device1}")
            tty_device="/dev/ttyACM0"
            flash_command="idf.py flash"
            cp configs/sdkconfig_display_ttgo_tdisplay.defaults sdkconfig.defaults
            break
            ;;
        "${device2}")
            tty_device="/dev/ttyUSB0"
            flash_command="idf.py -b 115200 flash"
            cp configs/sdkconfig_display_m5stickcplus.defaults sdkconfig.defaults
            break
            ;;
        "${device3}")
            tty_device="/dev/ttyACM0"
            flash_command="idf.py flash"
            cp configs/sdkconfig_display_m5blackgray.defaults sdkconfig.defaults
            break
            ;;
        "${device4}")
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
chosen_device="${choice}"

[ -f sdkconfig ] && rm sdkconfig
sed -i.bak '/CONFIG_DEBUG_MODE/d' ./sdkconfig.defaults
sed -i.bak '1s/^/CONFIG_LOG_DEFUALT_LEVEL_NONE=y\n/' sdkconfig.defaults

case "${machine}" in
    Linux*)
        while [ ! -c "${tty_device}" ]; do
            read -srn1 -p "Connect your ${chosen_device} and PRESS ANY KEY TO CONTINUE... " && echo
        done
        sudo chmod o+rw "${tty_device}"
        ;;
    macOS*)
        read -srk "?Connect your ${chosen_device}, click Allow on the popup, and PRESS ANY KEY TO CONTINUE... " && echo
        ;;
    MINGW*)
        echo "Windows is not supported." && exit 0;;
    *) echo "Unsupported OS: $(uname -s)" && exit 0
esac

echo -e "\nReady to install Jade ${jade_version} on your ${chosen_device}.\n(This process can take over 10 minutes.)"
case "${machine}" in
    Linux*)
        read -srn1 -p "PRESS ANY KEY TO CONTINUE... " && echo
        ;;
    macOS*)
        read -srk "?PRESS ANY KEY TO CONTINUE... " && echo
        ;;
    *) echo "Unsupported OS: $(uname -s)" && exit 0
esac

echo -ne "\nSTARTING the flash process in 5 seconds... "
sleep 5
echo
${flash_command}

echo -e "\nSUCCESS! Jade ${jade_version} is now installed on your ${chosen_device}."
