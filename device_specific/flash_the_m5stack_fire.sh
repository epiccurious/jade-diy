#!/bin/bash
set -e

esp_dir="${HOME}/esp"
esp_idf_git_dir="${esp_dir}/esp-idf"
esp_idf_git_tag="v5.0.1"
jade_git_dir="${HOME}/jade"

device="M5Stack FIRE"
echo "LINUX ONLY. Flashing the ${device}..."

sudo apt -qq update
sudo apt -qq install -y cmake git python3-pip python3-venv

[ -d "${esp_dir}" ] || mkdir "${esp_dir}"/
git clone -b "${esp_idf_git_tag}" --recursive https://github.com/espressif/esp-idf.git "${esp_idf_git_dir}"/
cd "${esp_idf_git_dir}"
git checkout a4afa44435ef4488d018399e1de50ad2ee964be8
./install.sh esp32
. "${esp_idf_git_dir}"/export.sh

git clone --recursive https://github.com/blockstream/jade "${jade_git_dir}"/
cd "${jade_git_dir}"/
cp configs/sdkconfig_display_m5fire.defaults sdkconfig.defaults

sed -i.bak '/CONFIG_DEBUG_MODE/d' ./sdkconfig.defaults
sed -i.bak '1s/^/CONFIG_LOG_DEFUALT_LEVEL_NONE=y\n/' sdkconfig.defaults
rm sdkconfig.defaults.bak

sudo chmod a+rw /dev/ttyACM0
idf.py flash
