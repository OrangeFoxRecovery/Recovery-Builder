#!/bin/bash

# Device
export FOX_BRANCH="fox_11.0"
export DT_LINK="https://github.com/OrangeFoxRecovery/device_oneplus_Nord.git -b fox_11.0"

export DEVICE="nord"
export OEM="oneplus"
export TARGET="recoveryimage"

export OUTPUT="OrangeFox*.zip"

# Kernel Source
# Uncomment the next line if you want to clone a kernel source.
export KERNEL_SOURCE="https://github.com/OnePlusOSS/android_kernel_oneplus_sm7250.git -b oneplus/SM7250_R_11.0"
export PLATFORM="sm7250" # Leave it commented if you want to clone the kernel to kernel/$OEM/$DEVICE

# Extra Command
export EXTRA_CMD="git clone https://github.com/OrangeFoxRecovery/Avatar.git misc"

# Not Recommended to Change
export SYNC_PATH="$HOME/work" # Full (absolute) path.
export USE_CCACHE=1
export CCACHE_SIZE="50G"
export CCACHE_DIR="$HOME/work/.ccache"
export J_VAL=16

if [ ! -z "$PLATFORM" ]; then
    export KERNEL_PATH="kernel/$OEM/$PLATFORM"
else
    export KERNEL_PATH="kernel/$OEM/$DEVICE"
fi
export DT_PATH="device/$OEM/$DEVICE"
