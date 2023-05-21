sudo apt -qq update
sudo apt -qq install -y cmake git python3-pip python3-venv

[ -d ${HOME}/esp ] || mkdir ${HOME}/esp
git clone -b v5.0.1 --recursive https://github.com/espressif/esp-idf.git ${HOME}/esp/esp-idf/
cd ${HOME}/esp/esp-idf
git checkout a4afa44435ef4488d018399e1de50ad2ee964be8
./install.sh esp32
. $HOME/esp/esp-idf/export.sh

git clone --recursive https://github.com/blockstream/jade ${HOME}/jade/
cd ${HOME}/jade/
cp configs/sdkconfig_display_ttgo_tdisplay.defaults sdkconfig.defaults

sed -i.bak '/CONFIG_DEBUG_MODE/d' ./sdkconfig.defaults
sed -i.bak '1s/^/CONFIG_LOG_DEFUALT_LEVEL_NONE=y\n/' sdkconfig.defaults
rm sdkconfig.defaults.bak

sudo chmod a+rw /dev/ttyACM0
idf.py flash