#!/bin/bash

# Source Configs
source "$CONFIG"

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="$TG_CHAT_ID" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Change to the Source Directry
cd "$SYNC_PATH"

# Sync Branch (will be used to fix legacy build system errors)
[[ -z "$SYNC_BRANCH" ]] && export SYNC_BRANCH=$(echo "$FOX_BRANCH" | cut -d_ -f2)

# Set-up ccache
[[ -z "$CCACHE_SIZE" ]] && ccache -M 10G || ccache -M "$CCACHE_SIZE"

# Empty the VTS Makefile
[[ "$FOX_BRANCH" == "fox_11.0" ]] && {
  rm -rf frameworks/base/core/xsd/vts/Android.mk
  touch frameworks/base/core/xsd/vts/Android.mk 2>/dev/null
}

# Send the Telegram Message
echo "
🦊 OrangeFox Recovery CI

✔️ The Build has been triggered!

📱 Device: $DEVICE
🖥 Build System: $FOX_BRANCH
🌲 Logs: <a href=\https://cirrus-ci.com/build/$CIRRUS_BUILD_ID\>Here</a>
" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "$TG_TEXT"
echo ""

# Prepare the Build Environment
source build/envsetup.sh

# Run the Extra Command
$EXTRA_CMD

# export some Basic Vars
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export LC_ALL="C"

# Default Build Type
[[ -z "$FOX_BUILD_TYPE" ]] && export FOX_BUILD_TYPE="Unofficial-CI"

# Default Maintainer's Name
[[ -z "$OF_MAINTAINER" ]] && export OF_MAINTAINER="Unknown"

# Set BRANCH_INT variable for future use
BRANCH_INT=$(echo "$SYNC_BRANCH" | cut -d. -f1)

# Magisk
[[ "$OF_USE_LATEST_MAGISK" == "true" ]] || [[ $OF_USE_LATEST_MAGISK = "1" ]] && {
  echo "Using the Latest Release of Magisk..."
  export FOX_USE_SPECIFIC_MAGISK_ZIP=$("ls" ~/Magisk/Magisk*.zip)
}

# Legacy Build Systems
[[ "$BRANCH_INT" -le "6" ]] && {
  export OF_DISABLE_KEYMASTER2=1 # Disable Keymaster2
  export OF_LEGACY_SHAR512=1 # Fix Compilation on Legacy Build Systems
}

# lunch the target
[[ "$BRANCH_INT" -ge "11" ]] && lunch twrp_${DEVICE}-eng || { echo "ERROR: Failed to lunch the target!" && exit 1; }

[[ ! "$BRANCH_INT" -ge "11" ]] && lunch omni_${DEVICE}-eng || { echo "ERROR: Failed to lunch the target!" && exit 1; }

# Build the Code
[[ -z "$J_VAL" ]] && mka -j$(nproc --all) $TARGET || { echo "ERROR: Failed to Build OrangeFox!" && exit 1; }

[[ "$J_VAL" == "0" ]] && mka $TARGET || { echo "ERROR: Failed to Build OrangeFox!" && exit 1; }
    
[[ ! -z "$J_VAL" ]] && [[ ! "$J_VAL" == "0" ]] && mka -j${J_VAL} $TARGET || { echo "ERROR: Failed to Build OrangeFox!" && exit 1; }

# Exit
exit 0
