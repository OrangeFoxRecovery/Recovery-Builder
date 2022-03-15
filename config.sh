#!/bin/bash

# Device
export FOX_BRANCH="fox_11.0"
export DT_LINK="https://github.com/karan2354/android_recovery_xiaomi_olivewood.git -b fox_11.0"

export DEVICE="olivewood"
export OEM="xiaomi"
export TARGET="recoveryimage"

export OUTPUT="OrangeFox*.zip"

# Extra Command
export EXTRA_CMD=""

# Not Recommended to Change
export SYNC_PATH="$HOME/work" # Full (absolute) path.
export USE_CCACHE=1
export CCACHE_SIZE="50G"
export CCACHE_DIR="$HOME/work/.ccache"
export J_VAL=16
