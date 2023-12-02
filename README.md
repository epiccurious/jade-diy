# Jade Do-It-Yourself Hardware Guide

This guide is designed for the general user who is not incompetant with computers and is looking to secure **less** than $100,000 (in 2023 prices) worth of bitcoin.

## Table of Contents

- [Background](#background)
  - [What is a Jade?](#what-is-a-jade)
  - [Motivation](#motivation)
  - [Who Should NOT Follow This Guide?](#who-should-not-follow-this-guide)
  - [Current Limitations of Third-Party DIY Hardware](#current-limitations-of-third-party-diy-hardware)
- [Overview of Hardware Options](#overview-of-hardware-options)
  - [TTGO T-Display](#ttgo-t-display)
  - [M5Stack M5StickC PLUS](#m5stack-m5stickc-plus)
  - [M5Stack Core Basic](#m5stack-core-basic)
  - [M5Stack FIRE v2.6](#m5stack-fire-v26)
- [Set Up Instructions](#set-up-instructions)
  - [Use the Semi-Automated Script](#use-the-semi-automated-script)
  - [Use a Device-Specific Script](#use-a-device-specific-script)
  - [Run the Commands Manually](#run-the-commands-manually)
- [Acknowledgements](#acknowledgements)

## Background

### What is a Jade?

[The Blockstream Jade](https://blockstream.com/jade) is a bitcoin-only hardware wallet that runs 100% on Open Source code.

The firmware that runs Jade can also run other general purpose hardware that shares the same ESP32 microcontroller.

### Motivation

Why Should I Follow This Guide?

Three words: **supply chain attacks**.

You understand that the person who sells you hardware for your bitcoin shouldn't know you use it for bitcoin.

**WARNING:** Do not hold **more** than $100,000 (in 2023 prices) on **any** hardware wallet including the Jade. For large amounts, refer to the "Who Should NOT Follow This Guide?" section.

### Who Should NOT Follow This Guide?

1. You want to secure more than $100,000 (in 2023 dollars) worth of bitcoin. For large amounts, install Linux yourself on dedicated laptops and use multisig on Bitcoin Core following [a best-practices self-custody guide](https://yeticold.com).

<!-- markdown-link-check-disable -->
2. You want to learn how to use the Jade hardware wallet. Refer to [the Jade's help center documentation](https://help.blockstream.com/hc/en-us/categories/900000061906-Blockstream-Jade/) or [contact Blockstream](https://help.blockstream.com/hc/en-us/requests/new) for software support.
<!-- markdown-link-check-enable -->

3. You're a normie who can't be bothered to learn how to operate a computer through the command line. We will be using the Terminal console, which some people find scary. It's not hard, I promise.

4. You aren't willing to use macOS or [Linux](https://ubuntu.com/tutorials/install-ubuntu-desktop). (This guide only supports macOS and Debian Linux for now but will eventually add support for other Linux distributions.)

### Current Limitations of Third-Party DIY Hardware

- No camera support. To build a DIY Jade with camera support, [please refer here](https://www.youtube.com/watch?v=V2yVKag2wlc).
- Need a documented process for updating firmware.

## Overview of Hardware Options

You are better off buying the hardware directly from the hardware vendor than through a third-party channel like Amazon or Alibaba. In many cases, it's cheaper to buy direct too.

### TTGO T-Display

![TTGO T-Display](img/TTGO-T-Display.jpg)

- **MSRP: [$8-$11](https://www.lilygo.cc/products/lilygo%C2%AE-ttgo-t-display-1-14-inch-lcd-esp32-control-board?variant=42720264683701), either the K164 or Q125 variant**
- Does not include a battery. Either keep it plugged in or add a generic battery for a few dollars.
- DO NOT confuse this hardware with the more expensive T-Display S3 or T-Display AMOLED products.


### M5Stack M5StickC PLUS

![M5Stack M5StickC PLUS](img/M5Stack-M5StickC-PLUS.jpg)

- **MSRP: [$20](https://shop.m5stack.com/products/m5stickc-plus-esp32-pico-mini-iot-development-kit)**
- Includes a built-in battery
- DO NOT confuse this hardware with the older, cheaper M5StickC. The newer PLUS verison with a larger screen is the one to buy.


### M5Stack Core Basic

![M5Stack Core Basic](img/M5Stack-Core-Basic.jpg)

- **MSRP: [$40](https://shop.m5stack.com/products/esp32-basic-core-lot-development-kit-v2-7)**
- Nice 3-button design


### M5Stack FIRE v2.6

![M5Stack FIRE](img/M5Stack-FIRE.jpg)

- **MSRP: [$50](https://shop.m5stack.com/products/m5stack-fire-iot-development-kit-psram-v2-6)**
- Nice 3-button design, a bigger battery, and a magnetic charging base

## Set Up Instructions

There are three options for flashing your device:
- [**Install with the Semi-Automated Script**](#install-with-the-semi-automated-script) (easiest way)
- [**Install with a Device-Specific Script**](#install-with-a-device-specific-script) (other easy way)
- [**Install by Running the Code Manually**](#install-by-running-the-code-manually) (harder way)

### Use the Semi-Automated Script

This option is recommended for the average user who doesn't know how to read and write bash.

1. Open the Terminal.
    - On Linux, press `Ctrl+Alt+T`.
    - On macOS, press `Command+Space`, type terminal, and press `return`.

2. Copy-paste the following full command in Terminal (you might have to scroll right):
    ```bash
    /bin/bash -c "$(curl -sSL https://github.com/epiccurious/jade-diy/raw/master/flash_your_device)"
    ```

3. When the script asks, choose your device (#1-#4).

After the script completes, you should see the Jade initialization screen on your device.

### Use a Device-Specific Script

1. Open the Terminal. On Linux, press `Ctrl+Alt+T`. On macOS, press `Command+Space`, type terminal, and press `return`.

2. Connect your device to your computer via USB.

3. Run one of the following in Terminal:
    - If you're using the TTGO T-Dispay, run:
        ```
        /bin/bash -c "$(curl -sSL https://github.com/epiccurious/jade-diy/raw/master/device_specific/flash_the_ttgo_tdisplay)"
        ```
    - If you're using the M5Stack M5StickC PLUS, run:
        ```
        /bin/bash -c "$(curl -sSL https://github.com/epiccurious/jade-diy/raw/master/device_specific/flash_the_m5stack_m5stickc_plus)"
        ```
    - If you're using the M5Stack Core Basic, run:
        ```
        /bin/bash -c "$(curl -sSL https://github.com/epiccurious/jade-diy/raw/master/device_specific/flash_the_m5stack_core_basic)"
        ```
    - If you're using the M5Stack FIRE, run:
        ```
        /bin/bash -c "$(curl -sSL https://github.com/epiccurious/jade-diy/raw/master/device_specific/flash_the_m5stack_fire)"
        ```

After the script completes, you should see the Jade initialization screen on your device.

### Run the Commands Manually

This options is provided for people who want to run the commands themselves.

1. Open the Terminal. On Linux, press `Ctrl+Alt+T`. On macOS, press `Command+Space`, type terminal, and press `return`.

2. Install the required software packages. On a slow computer, this step can take over 20 minutes. Copy-and-paste the following lines into Terminal:
    ```bash
    sudo apt update
    sudo apt install -y cmake git python3-pip python3-venv
    [ -d ${HOME}/esp ] || mkdir ${HOME}/esp
    git clone -b v5.1.1 --recursive https://github.com/espressif/esp-idf.git ${HOME}/esp/esp-idf
    cd "${HOME}"/esp/esp-idf
    ./install.sh esp32
    . ./export.sh
    ```
TODO: Add instructions for installing macOS dependendies.
  
3. Download the Jade source code. Copy-and-paste the following lines into Terminal:
    ```bash
    git clone --recursive https://github.com/blockstream/jade "${HOME}"/jade
    cd "${HOME}"/jade/
    git checkout $(git tag | grep -v miner | sort -V | tail -1)
    ```
  
4. Load the pre-built configuration file for your DIY hardware.
    - For the TTGO T-Display, run:
        ```bash
        cp configs/sdkconfig_display_ttgo_tdisplay.defaults sdkconfig.defaults
        ```
    - For the M5Stack M5StickC Plus, run:
        ```bash
        cp configs/sdkconfig_display_m5stickcplus.defaults sdkconfig.defaults
        ```
    - For the M5Stack Core, run:
        ```bash
        cp configs/sdkconfig_display_m5blackgray.defaults sdkconfig.defaults
        ```
    - For the M5Stack Fire, run:
        ```bash
        cp configs/sdkconfig_display_m5fire.defaults sdkconfig.defaults
        ```

5. Modify the configuration file you just loaded to disable logging in debug mode (a.k.a. "research and development" mode).
    ```bash
    sed -i.bak '/CONFIG_DEBUG_MODE/d' ./sdkconfig.defaults
    sed -i.bak '1s/^/CONFIG_LOG_DEFUALT_LEVEL_NONE=y\n/' sdkconfig.defaults
    rm sdkconfig.defaults.bak
    ```
  
6. Connect your device to your computer via USB.

7. Enable read-write permissions for your device.
    ```bash
    [ -f /dev/ttyACM0 ] && sudo chmod o+rw /dev/ttyACM0
    [ -f /dev/ttyUSB0 ] && sudo chmod a+rw /dev/ttyUSB0
    ```
TODO: Add macOS instructions.

8. Flash (install) Jade onto your device. On a slow computer, this step can take over 10 minutes. Run the following command in Terminal:
    ```bash
    idf.py -b 115200 flash
    ```

After the build and flash process completes, you should see the Jade initialization screen on your device.

## Acknowledgements

Inspiration for this project came from:
- [Blockstream Jade](https://github.com/Blockstream/Jade/graphs/contributors)
- [@YTCryptoGuide](https://twitter.com/YTCryptoGuidelink) ([YouTube](https://youtube.com/CryptoGuide)).
