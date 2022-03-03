#!/bin/bash

# Source Vars
source vars.sh

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="Markdown" \
	-d text="$1"
}

# Change to the Source Directry
cd $SYNC_PATH

# Sync Branch (will be used to fix legacy build system errors)
if [ -z "$SYNC_BRANCH" ]; then
    export SYNC_BRANCH=$(echo ${FOX_BRANCH} | cut -d_ -f2)
fi

# Set-up ccache
if [ -z "$CCACHE_SIZE" ]; then
    ccache -M 10G
else
    ccache -M ${CCACHE_SIZE}
fi

# Empty the VTS Makefile
if [ -f frameworks/base/core/xsd/vts/Android.mk ]; then
    rm -rf frameworks/base/core/xsd/vts/Android.mk && touch frameworks/base/core/xsd/vts/Android.mk
fi

# Send the Telegram Message
printf \
"
🦊 OrangeFox Recovery CI

✔️ The Build has been Triggered!

📱 Device: ${DEVICE}
🌲 Logs: [https://cirrus-ci.com/build/${CIRRUS_BUILD_ID}](https://cirrus-ci.com/build/${CIRRUS_BUILD_ID})
🖥 Build System: ${FOX_BRANCH}
" > tg.md

TG_TEXT=$(< tg.md)

telegram_message "${TG_TEXT}"
echo " "

# Prepare the Build Environment
source build/envsetup.sh || { echo "ERROR: Failed to source build/envsetup.sh" && exit 1; }

# Run the Extra Command
$EXTRA_CMD

# export some Basic Vars
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export LC_ALL="C"

# Default Build Type
if [ -z "$FOX_BUILD_TYPE" ]; then
    export FOX_BUILD_TYPE="Unofficial-CI"
fi

# Default Maintainer's Name
[ -z "$OF_MAINTAINER" ] && export OF_MAINTAINER="Unknown"

# Legacy Build Systems
if [ $(echo $SYNC_BRANCH | cut -d. -f1) -le 6 ]; then
    export OF_DISABLE_KEYMASTER2=1 # Disable Keymaster2
    export OF_LEGACY_SHAR512=1 # Fix Compilation on Legacy Build Systems
fi

# lunch the target
if [ "$FOX_BRANCH" = "fox_11.0" ]; then
    lunch twrp_${DEVICE}-eng || { echo "ERROR: Failed to lunch the target!" && exit 1; }
else
    lunch omni_${DEVICE}-eng || { echo "ERROR: Failed to lunch the target!" && exit 1; }
fi

# Build the Code
if [ -z "$J_VAL" ]; then
    mka -j$(nproc --all) $TARGET || { echo "ERROR: Failed to Build OrangeFox!" && exit 1; }
elif [ "$J_VAL"="0" ]; then
    mka $TARGET || { echo "ERROR: Failed to Build OrangeFox!" && exit 1; }
else
    mka -j${J_VAL} $TARGET || { echo "ERROR: Failed to Build OrangeFox!" && exit 1; }
fi

# Exit
exit 0
