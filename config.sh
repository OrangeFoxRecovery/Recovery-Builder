#!/bin/bash

# Device
export FOX_BRANCH="fox_11"
export DT_LINK="https://github.com/Fr0ztyy43/twrp_device_redmi_begonia -b 11"

export DEVICE="begonia"
export OEM="redmi"

# Build Target
## "recoveryimage" - for A-Only Devices without using Vendor Boot
## "bootimage" - for A/B devices without recovery partition (and without vendor boot)
## "vendorbootimage" - for devices Using vendor boot for the recovery ramdisk (Usually for devices shipped with Android 12 or higher)
export TARGET="recoveryimage"

export OUTPUT="OrangeFox-begonia.zip"

# Additional Dependencies (eg: Kernel Source)
export KERNEL_SOURCE="https://github.com/theimpulson/android_kernel_redmi_mt6785 -b lineage-17.1 kernel/redmi/begonia"
# Format: "repo dest"
DEPS=(
    "https://github.com/OrangeFoxRecovery/Avatar.git misc"
)

# Extra Command
export EXTRA_CMD="export OF_MAINTAINER=Fr0ztyy43"
export ALLOW_MISSING_DEPENDENCIES=true
# Magisk
## Use the Latest Release of Magisk for the OrangeFox addon
export OF_USE_LATEST_MAGISK=false


# Not Recommended to Change
export SYNC_PATH="$HOME/work" # Full (absolute) path.
export USE_CCACHE=1
export CCACHE_SIZE="50G"
export CCACHE_DIR="$HOME/work/.ccache"
export J_VAL=16
