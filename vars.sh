#!/bin/bash

# Device
export FOX_BRANCH="fox_9.0"
export DT_LINK="https://github.com/yashraj22/omni_device_A37f.git -b OFX7.1"

export DEVICE="A37f"
export OEM="oppo"
export TARGET="recoveryimage"

export DT_PATH="device/$OEM/$DEVICE"
export OUTPUT="OrangeFox*.zip"

# Extra Command
export EXTRA_CMD="git clone https://github.com/OrangeFoxRecovery/Avatar.git misc"

# Not Recommended to Change
export SYNC_PATH="$HOME/work" # Full (absolute) path. Use "$HOME" instead of "~".
export USE_CCACHE=1
export CCACHE_SIZE="50G"
export CCACHE_DIR="$HOME/work/.ccache"
export J_VAL=16
