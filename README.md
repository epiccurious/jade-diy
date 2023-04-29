# Jade Do-It-Yourself Hardware Guide

YOU SHOULD NOT read this guide yet. It's still under development and requires testing across many hardware and operating systems.

If you don't already know what you're doing, do not follow this guide.

## What is a Jade?

Jade is a bitcoin-only hardware wallet that runs 100% on Open Source code. The firmware that runs Jade can also run other ESP32-compatible.

## Why Should I NOT Read This Guide?

1. You have questions about how to use the Jade hardware wallet. Refer to the manufacturer's documentation or contact them instead.

2. You can't be bothered to learn how to operate a computer. We will be using the Terminal.

3. You are not willing to use Linux. (This guide only supports Linux Ubuntu for now but planning to add macOS support soon.)

## Why Should I Read This Guide?

Three words: **supply chain attacks**.

You understand that the person who sells you hardware for your bitcoin should have zero idea that you use it to store bitcoin.

Don't hold more than $100k or more than would be life-changing on a Jade.

After following the steps below, you should transfer 

## What Hardware Should I Buy?

You are better off buying the hardware directly from the hardware vendor than through a third-party channel like Amazon or Alibaba. In many cases, it's cheaper to buy direct too.

- [M5Stack Core](https://shop.m5stack.com/products/esp32-basic-core-iot-development-kit-v2-6)
- [M5Stack Fire](https://shop.m5stack.com/products/m5stack-fire-iot-development-kit-psram-v2-6)
- [M5Stack M5StickC PLUS](https://shop.m5stack.com/products/m5stickc-plus-esp32-pico-mini-iot-development-kit)
    - DO NOT confuse this hardware with the M5StickC. The newer PLUS verison with a larger screen is the one to buy.
- [TTGO T-Display](https://www.lilygo.cc/products/lilygo%C2%AE-ttgo-t-display-1-14-inch-lcd-esp32-control-board?variant=42720264683701)
    - DO NOT confuse this hardware with the more expensive T-Display S3 or T-Display AMOLED. The cheaper T-Display is the one to buy.
    - The best variant for most people is the `K164`, which is the listed as `T-Display 16MB With Shell Not Solder version`.
    - If you prefer just the raw board, buy the `Q125`, whic is listed as `T-Display 16MB`.

## Limitations of Third-Party Hardware

- No camera... yet.
- The T-Display doesn't have a battery. You can either (1) keep it plugged in to a wall outlet, keep it plugged into a portable battery charger, or add a generic battery for a few dollars.
- How do you do firmware updates?
- If you enable Secure Boot, you can't lose the pem key.

## Beginner Instructions (without Secure Boot)

1. Open the Terminal by pressing `Ctrl+Alt+T`.

2. Install the required software packages. Copy-and-paste the following lines into Terminal:
    ```bash
    sudo apt -qq update
    sudo apt -qq install -y cmake git python3-pip python3-venv
    [ -d ${HOME}/esp } || mkdir ${HOME}/esp
    git clone -b v5.0.1 --recursive https://github.com/espressif/esp-idf.git ${HOME}/esp/esp-idf/
    cd ${HOME}/esp/esp-idf
    git checkout a4afa44435ef4488d018399e1de50ad2ee964be8
    ./install.sh esp32
    . $HOME/esp/esp-idf/export.sh
    ```
    - On a slow internet connection and slow computer, this step can take over 10 minutes. 
  
3. Download the Jade source code and load the most recent stable version. Copy-and-paste the following lines into Terminal:
    ```bash
    git clone --recursive https://github.com/blockstream/jade ${HOME}/jade/
    cd ${HOME}/jade/
    git checkout $(git tag | grep -v miner | sort -V | tail -1)
    ```
  
4. Figure out which pre-built configuration file to use under the `config/` sub-directory. We will refer to this sub-directory and filename in the next step.
    ```bash
    ls -l configs/
    ```
    - For the M5Stack Core, use `configs/sdkconfig_display_m5blackgray.defaults`
    - For the M5Stack Fire, use `configs/sdkconfig_display_m5fire.defaults`
    - For the M5Stack M5StickC Plus, use `configs/sdkconfig_display_m5stickcplus.defaults`.
    - For the TTGO T-Display, use `configs/sdkconfig_display_ttgo_tdisplay.defaults`.

5. Load the sdkconfig file you found from the last step into `sdkconfig.defaults`. As an example, if you are flashing a TTGO T-Display, you would run in Terminal:
    ```bash
    cp configs/sdkconfig_display_ttgo_tdisplay.defaults sdkconfig.defaults
    ```

6. Modify the confiugration to disable logging in debug mode ("research and development" mode). Open the file using:
    ```bash
    nano sdkconfig.defaults
    ```
    - Remove the line about ten down that says: `CONFIG_DEBUG_MODE=y`
    - Add a line at the top that says: `CONFIG_LOG_DEFAULT_LEVEL_NONE=y`
    - When you are finished, save the file by pressing `Ctrl+X` then pressing `y` then pressing `return`.
  
7. If you haven't done it yet, plug in your device.

8. . Run the following command in Terminal:
    ```bash
    idf.py flash
    ```
    - Please note: On a slow computer, this step can take ___ minutes.

8. You should see the Jade initialization screen on your device.

## Advanced Instructions (Secure Boot)

This section is still in progress.
