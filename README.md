# Jade Do-It-Yourself Hardware Guide

This guide is designed for the general user who is not incompetant with computers.

## What is a Jade?

Jade is a bitcoin-only hardware wallet that runs 100% on Open Source code.

The firmware that runs Jade can also run other ESP32-based devices, which are listed below.

## Who Should NOT Follow This Guide?

1. You want to secure more than $100,000 (in 2023 dollars) worth of bitcoin. For large amounts, use multisig with Bitcoin Core on a cheap, dedicated laptop. The recommended guide is [the Yeti Level 3 Wallet](https://yeticold.com).

2. You want to learn how to use the Jade hardware wallet. Refer to [the Jade's help center documentation](https://help.blockstream.com/hc/en-us/categories/900000061906-Blockstream-Jade) or [contact Blockstream](https://help.blockstream.com/hc/en-us/requests/new) for software support.

3. You're a normie who can't be bothered to learn how to operate a computer through the command line. We will be using the Terminal console which normies find scary. It's not not hard, I promise.

4. You are not willing to use Linux. (This guide only supports Linux Ubuntu for now but planning to add macOS support soon once I iron out the brew dependencies.)

## Why Should I Read This Guide?

Three words: **supply chain attacks**.

You understand that the person who sells you hardware for your bitcoin should have zero idea that you use it to store bitcoin.

You're looking to secure less than $100,000 (in 2023 prices) worth of bitcoin.

**WARNING:** Do not hold more than $100,000 (in 2023 prices) on a hardware wallet.

## What Hardware Should I Buy?

You are better off buying the hardware directly from the hardware vendor than through a third-party channel like Amazon or Alibaba. In many cases, it's cheaper to buy direct too.

- $10 [TTGO T-Display](https://www.lilygo.cc/products/lilygo%C2%AE-ttgo-t-display-1-14-inch-lcd-esp32-control-board?variant=42720264683701), either the K164 or Q125 variant
    - Does not include a battery. Either keep it plugged in or add a generic battery for a few dollars.
    - DO NOT confuse this hardware with the more expensive T-Display S3 or T-Display AMOLED products.
    ![TTGO T-Display](img/TTGO-T-Display.jpg)

- $20 [M5Stack M5StickC PLUS](https://shop.m5stack.com/products/m5stickc-plus-esp32-pico-mini-iot-development-kit)
    - Includes a built-in battery
    - DO NOT confuse this hardware with the older, cheaper M5StickC. The newer PLUS verison with a larger screen is the one to buy.
    ![M5Stack M5StickC PLUS](img/M5Stack-M5StickC-PLUS.jpg)

- $40 [M5Stack Core Basic](https://shop.m5stack.com/products/esp32-basic-core-iot-development-kit-v2-6)
    - Nice 3-button design
    ![M5Stack Core Basic](img/M5Stack-Core-Basic.jpg)

- $50 [M5Stack FIRE v2.6](https://shop.m5stack.com/products/m5stack-fire-iot-development-kit-psram-v2-6)
    - Nice 3-button design, a bigger battery, and a magnetic charging base
    ![M5Stack FIRE](img/M5Stack-FIRE.jpg)

## Current Limitations of Third-Party DIY Hardware

- No camera support... yet
- Need to document how to perform firmware updates

## Set Up Instructions

1. Open the Terminal by pressing `Ctrl+Alt+T`.

2. Install the required software packages. On a slow computer, this step can take over 20 minutes. Copy-and-paste the following lines into Terminal:
    ```bash
    sudo apt update
    sudo apt install -y cmake git python3-pip python3-venv
    [ -d ${HOME}/esp ] || mkdir ${HOME}/esp
    git clone -b v5.0.1 --recursive https://github.com/espressif/esp-idf.git ${HOME}/esp/esp-idf/
    cd ${HOME}/esp/esp-idf
    git checkout a4afa44435ef4488d018399e1de50ad2ee964be8
    ./install.sh esp32
    . $HOME/esp/esp-idf/export.sh
    ```
  
3. Download the Jade source code. Copy-and-paste the following lines into Terminal:
    ```bash
    git clone --recursive https://github.com/blockstream/jade ${HOME}/jade/
    cd ${HOME}/jade/
    ```
  
4. Load the pre-built configuration file for your DIY hardware.
    - For the M5Stack Core, run:
        ```bash
        cp configs/sdkconfig_display_m5blackgray.defaults sdkconfig.defaults
        ```
    - For the M5Stack Fire, run:
        ```bash
        cp configs/sdkconfig_display_m5fire.defaults sdkconfig.defaults
        ```
    - For the M5Stack M5StickC Plus, run:
        ```bash
        cp configs/sdkconfig_display_m5stickcplus.defaults sdkconfig.defaults
        ```
    - For the TTGO T-Display, run:
        ```bash
        cp configs/sdkconfig_display_ttgo_tdisplay.defaults sdkconfig.defaults
        ```

6. Modify the configuration file you just loaded to disable logging in debug mode (a.k.a. "research and development" mode).
    ```bash
    sed -i.bak '/CONFIG_DEBUG_MODE/d' ./sdkconfig.defaults
    sed -i.bak '1s/^/CONFIG_LOG_DEFUALT_LEVEL_NONE=y\n/' sdkconfig.defaults
    rm sdkconfig.defaults.bak
    ```
  
7. If you haven't done it yet, your device into your computer via USB.

8. Enable read-write permissions for your device.
    ```bash
    sudo chmod a+rw /dev/ttyACM0
    ```

9. Flash (install) Jade onto your device. On a slow computer, this step can take over 10 minutes. Run the following command in Terminal:
    ```bash
    idf.py flash
    ```

10. You should see the Jade initialization screen on your device.
