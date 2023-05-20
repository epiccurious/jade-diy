#!/bin/bash
set -e

sudo apt -qq update
sudo apt -qq install -y cmake git python3-pip python3-venv

esp_git_dir="${HOME}/esp"
jade_git_dir="${HOME}/jade"
device1="TTGO T-Display"
device2="M5Stack M5StickC PLUS"
device3="M5Stack Core Basic"
device4="M5Stack FIRE"

if [ ! -f $esp_git_dir/esp-idf/export.sh ]
then
    [ -d $esp_git_dir ] || mkdir $esp_git_dir
    git clone -b v5.0.1 --recursive https://github.com/espressif/esp-idf.git $esp_git_dir/esp-idf/
    cd $esp_git_dir/esp-idf
    git checkout a4afa44435ef4488d018399e1de50ad2ee964be8
    ./install.sh esp32
fi
. $esp_git_dir/esp-idf/export.sh

[ -d ${jade_git_dir} ] || git clone --recursive https://github.com/blockstream/jade ${jade_git_dir}
cd ${jade_git_dir}

clear

PS3='Please enter your choice: '
options=("$device1" "$device2" "$device3" "$device4" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "$device1")
            echo "You chose option $REPLY, the $device1."
            cp configs/sdkconfig_display_ttgo_tdisplay.defaults sdkconfig.defaults
            break
            ;;
        "$device2")
            echo "You chose option $REPLY, the $device1."
            cp configs/sdkconfig_display_m5stickcplus.defaults sdkconfig.defaults
            break
            ;;
        "$device3")
            echo "You chose option $REPLY, the $opt."
            cp configs/sdkconfig_display_m5blackgray.defaults sdkconfig.defaults
            break
            ;;
        "$device4")
            echo "You chose option $REPLY, the $opt."
            cp configs/sdkconfig_display_m5fire.defaults sdkconfig.defaults
            break
            ;;
        "Quit")
            echo "You chose to quit."
            exit 0
            ;;
        *) echo "You entered $REPLY which is invalid."
    esac
done

sed -i.bak '/CONFIG_DEBUG_MODE/d' ./sdkconfig.defaults
sed -i.bak '1s/^/CONFIG_LOG_DEFUALT_LEVEL_NONE=y\n/' sdkconfig.defaults

if [[ $opt == $device2 ]]
then
    sudo chmod a+rw /dev/ttyUSB0
    idf.py -b 115200 flash
else
    sudo chmod a+rw /dev/ttyACM0
    idf.py flash
fi 

echo "SUCCESS! Your device should be properly flashed now."