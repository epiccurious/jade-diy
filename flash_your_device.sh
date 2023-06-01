#!/bin/bash
set -e

if [ `whoami` != root ]; then
    echo -e "ERROR: Please run the script with elevated permissions like this:\n  sudo ~/jade-diy/flash_your_device.sh"
    exit 1
fi

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

        if [ -f /etc/os-release ]; then
            os_id=$(grep "^ID=" /etc/os-release | cut -c 4- | tr -d '"')
            os_id_like=$(grep "^ID_LIKE=" /etc/os-release | cut -c 9- | tr -d '"')
            os_name=$(grep "^NAME=" /etc/os-release | cut -c 6- | tr -d '"')
            os_prettyname=$(grep "^PRETTY_NAME=" /etc/os-release | cut -c 13- | tr -d '"')
        else
            echo "ERROR: Unable to detect ${machine} distro. Please report this error."
            uname -a
            ls -l /etc/*release
            exit 1
        fi
        
        echo "Detected ${machine} distribution ${os_id}, ${os_prettyname}."
        
        echo -n "Checking for cmake, git, pip, and venv... "
        case $os_id in
            debian|?ubuntu|linuxmint|zorin|neon|pop)
                apt-get -qq update
                apt-get -qq install -y -o=Dpkg::Use-Pty=0 cmake git python3-pip python3-venv &> /dev/null
                ;;
            gentoo)
                echo -e "\nNote: ${os_id} (${os_prettyname}) is under development"
                emerge --quiet --sync
                emerge --quiet dev-python/pip dev-python/virtualenv
                ;;
            *centos*)
                echo -e "\nNote: ${os_id} (${os_prettyname}) is under development"
                yum -y -q -e 0 install cmake gcc git make
                curl -O https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz
                tar -xzf Python-3.8.1.tgz
                cd Python-3.8.1/
                ./configure --enable-optimizations
                make
                ;;
            fedora)
                dnf -qy install cmake git python3-pip python3-virtualenv &> /dev/null
                ;;
            rhel)
                subscription-manager remove --all
                subscription-manager unregister
                subscription-manager clean
                subscription-manager register
                subscription-manager refresh
                subscription-manager list --available
                subscription-manager attach --pool=Pool-ID
                ;;
            arch)
                echo -e "\nNote: ${os_id} (${os_prettyname}) is under development"
                pacman --noconfirm -Sy cmake git python-pip python-virtualenv
                ;;
            manjaro|endeavouros|garuda)
                pacman --noconfirm -Sy cmake git make python-pip python-virtualenv &>/dev/null
                ;;
            opensuse)
                echo -e "\nNote: ${os_id} (${os_prettyname}) is under development"
                exit 1
                ;;
            opensuse-leap)
                echo -e "\nNote: ${os_id} (${os_prettyname}) is under development"
                zypper -qn si -d python3
                wget https://www.python.org/ftp/python/3.10.9/Python-3.10.9.tgz
                #wget --no-check-certificate https://www.python.org/ftp/python/3.10.9/Python-3.10.9.tgz
                tar -xvzf Python-*.tgz 
                cd Python-*/
                ./configure --prefix=/usr/local/python/ --with-openssl=/usr/local/openssl --enable-optimizations
                make
                sudo make install
                echo "$(which python3)"
                sudo mv /usr/bin/python3 /usr/bin/python3.backup
                #sudo mv /usr/bin/pip3 /usr/bin/pip3.backup
                #ln -s /usr/local/python/bin/python3 /usr/bin/python3
                #ln -s /usr/local/python/bin/pip3 /usr/bin/pip3
                #which python3
                #sudo ln -s /usr/local/python/lib64/python3.10/lib-dynload/ /usr/local/python/lib/python3.10/lib-dynload
                #pip3 install virtualenv
                #export PATH="/home/${USER}/.local/bin:$PATH"
                ;;
            tinycore)
                echo -e "\nNote: ${os_id} (${os_prettyname}) is under development"
                sudo -u "tc" tce-load -wil bash.tcz cmake.tcz git.tcz make.tcz python3.9.tcz usb-serial-6.1.2-tinycore.tcz
                python3 -m ensurepip
                pip3 install virtualenv
                ;;
            solus)
                echo -e "\nNote: ${os_id} (${os_prettyname}) is under development"
                eopkg update-repo
                eopkg install -y cmake git &> /dev/null
                yes | pip3 install virtualenv -q
                exit 1
                ;;
            alpine)
                echo -e "\nNote: ${os_id} (${os_prettyname}) is under development"
                #setup-interfaces
                #ip link set dev eth0 up
                #/etc/init.d/networking --quiet start &
                #ping 1.1.1.1
                exit 1
                ;;
            freebsd)
                echo -e "\nNote: ${os_id} (${os_prettyname}) is under development"
                exit 1
                ;;
            *)
                if [ -n "${os_id_like}" ]; then
                    echo -e "\nOS ID_LIKE: ${os_id_like}"
                    echo "DEV TO-DO:  Check for delimeters, pull out first word, and run commands for that distro."
                    os_first_id_like=$(echo ${os_id_like} | cut -d " " -f1 | tr -d '"')
                    #os_first_id_like="${os_first_id_like:1}"
                    echo "Trying again with ${os_first_id_like}"
                    os_id="${os_first_id_like}"
                    
                    #if [ "${os_first_id_like}" = "debian" ] || [ "${os_first_id_like}" = "ubuntu" ]; then
                    #    apt-get -qq update
                    #    apt-get -qq install -y -o=Dpkg::Use-Pty=0 cmake git python3-pip python3-venv &> /dev/null
                    #fi
                else
                    echo "Error: Unknowon Linux distribution '${o_id}'."
                    [ -f /etc/os-release ] && cat /etc/os-release
                    uname -a
                    ls -l /etc/*release
                    echo "Please report this error."
                    exit 1
                fi
                ;;
        esac
        echo "ok."
        ;;

    Darwin*)
        machine="macOS"
        echo "Detected ${machine}."
        echo -n "Checking for cmake... "
        if ! command -v cmake &> /dev/null; then
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
                #cmake_macos_volume="/Volumes/$(basename ${cmake_macos_url} .dmg)"
                
                if [ ! -f ${HOME}/Downloads/${cmake_macos_dmg} ]
                then
                    echo -ne "\n  Downloading CMake... "
                    #wget --quiet -P "${HOME}" "${cmake_macos_url}"
                    #wget --quiet -P "${HOME}/Downloads" "${cmake_macos_url}"
                    curl -sL "${cmake_macos_url}" --output "${HOME}"/Downloads/"${cmake_macos_dmg}"
                    echo "ok."
                fi

                echo -e "\n************************************************************"
                echo "ERROR: Automatic installation of CMake is not supported yet."
                echo "Please manually install \"${cmake_macos_dmg}\"."
                echo "Please open the file from your Downloads folder."
                echo -e "************************************************************\n"
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
    cd "${esp_idf_git_dir}"/
    git checkout --quiet "${esp_idf_git_tag}"
    git submodule update --quiet --init --recursive
    echo "ok."
    echo -n "  Installing the framework... "
    ./install.sh esp32 > /dev/null
fi
. "${esp_idf_git_dir}"/export.sh > /dev/null
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
echo

[ -f sdkconfig ] && rm sdkconfig
sed -i.bak '/CONFIG_DEBUG_MODE/d' ./sdkconfig.defaults
sed -i.bak '1s/^/CONFIG_LOG_DEFUALT_LEVEL_NONE=y\n/' sdkconfig.defaults

case "${machine}" in
    Linux*)
        while [ ! -c "${tty_device}" ]; do
            read -srn1 -p "Connect your ${chosen_device} and PRESS ANY KEY to continue... " && echo
        done
        chmod o+rw "${tty_device}"
        ;;
    macOS*)
        #macos_usb_serial=$(ioreg -p IOUSB -n "USB Single Serial" | grep "USB Serial Number" | cut -c 34-43)
        
        #[ -z "${macos_usb_serial}" ] && echo "serial does not exist"
        
        #while [ -z "${macos_usb_serial}" ]
        #do
        #    echo -e "Connect your ${chosen_device} with a USB-C cable,\n  click \"Allow\" if you see a macOS security popup,"
        #    sleep 5
        #    macos_usb_serial=$(ioreg -p IOUSB -n "USB Single Serial" | grep "USB Serial Number" | cut -c 34-43)

        #done
        echo -e "Connect your ${chosen_device} with a USB-C cable,\n  click \"Allow\" if you see a macOS security popup,"
        read -srn1 -p "  and PRESS ANY KEY to continue... " && echo
        ;;
    *) echo "Unsupported OS: $(uname -s)" && exit 0
esac

echo -e "\nReady to install Jade ${jade_version} on your ${chosen_device}.\n  (This process can take over 10 minutes.)"
read -srn1 -p "  PRESS ANY KEY to continue... " && echo

final_confirmation_sleep_time="10"
echo -ne "\nPlease wait ${final_confirmation_sleep_time} seconds or press Ctrl+C to cancel... "
sleep "${final_confirmation_sleep_time}"
echo
${flash_command}

echo -e "\nSUCCESS! Jade ${jade_version} is now installed on your ${chosen_device}."
