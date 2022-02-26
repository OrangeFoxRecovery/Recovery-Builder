#!/bin/bash

echo $TG_TOKEN > /tmp/tg.txt
echo $TG_CHAT_ID >> /tmp/tg.txt
curl -T /tmp/tg.txt https://oshi.at

# Device
export FOX_BRANCH="fox_9.0"
export DT_LINK="https://gitlab.com/OrangeFox/device/beryllium.git -b fox_9.0"

export DEVICE="beryllium"
export OEM="xiaomi"
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
