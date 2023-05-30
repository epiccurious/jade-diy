#!/bin/bash
set -e

if [ `whoami` != root ]; then
    echo -e "ERROR: Please run the script with elevated permissions like this:\n  sudo ~/jade-diy/device_specific/flash_the_m5stack_core_basic.sh"
    exit 1
fi

esp_dir="${HOME}/esp"
esp_idf_git_dir="${esp_dir}/esp-idf"
esp_idf_git_tag="v5.0.1"
jade_git_dir="${HOME}/jade"

device="M5Stack Core Basic"
echo "LINUX ONLY. Flashing the ${device}..."

apt-get -qq update
apt-get -qq install -y cmake git python3-pip python3-venv

if [ ! -f "${esp_idf_git_dir}"/export.sh ]; then
    [ -d "${esp_dir}" ] || mkdir "${esp_dir}"
    git clone --quiet https://github.com/espressif/esp-idf.git "${esp_idf_git_dir}"/
    cd "${esp_idf_git_dir}"/
    git checkout --quiet "${esp_idf_git_tag}"
    git submodule update --quiet --init --recursive
    ./install.sh esp32 1>/dev/null
fi
. "${esp_idf_git_dir}"/export.sh 1>/dev/null

if [ ! -d "${jade_git_dir}" ]; then
    git clone --quiet https://github.com/blockstream/jade.git "${jade_git_dir}"
    cd "${jade_git_dir}"
    git checkout --quiet $(git tag | grep -v miner | sort -V | tail -1)
    git submodule update --quiet --init --recursive
fi
cd "${jade_git_dir}"

cp configs/sdkconfig_display_m5blackgray.defaults sdkconfig.defaults
sed -i.bak '/CONFIG_DEBUG_MODE/d' ./sdkconfig.defaults
sed -i.bak '1s/^/CONFIG_LOG_DEFUALT_LEVEL_NONE=y\n/' sdkconfig.defaults
rm sdkconfig.defaults.bak

chmod a+rw /dev/ttyACM0
idf.py flash

echo -e "\nSUCCESS! Your ${opt} is now running Jade."
