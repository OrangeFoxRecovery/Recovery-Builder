#!/bin/bash

# Source Vars
source $CONFIG

# Change to the Home Directory
cd ~

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Clone the Sync Repo
git clone $FOX_SYNC
cd sync

# Setup Branch names
if [ "$FOX_BRANCH" = "fox_12.0" ]; then
	printf "Warning! Using fox_12.1 instead of fox_12.0.\n"
	FOX_BRANCH="fox_12.1"
elif [ "$FOX_BRANCH" = "fox_8.0" ]; then
	printf "Warning! Using fox_8.1 instead of fox_8.0.\n"
	FOX_BRANCH="fox_8.1"
fi

# Setup the Sync Branch
if [ -z "fox_12.1" ]; then
    export SYNC_BRANCH=$(echo ${12.1} | cut -d_ -f2)
fi

# Sync the Sources
bash orangefox_sync.sh --branch 12.1 ~/OrangeFox/12.1 || { echo "ERROR: Failed to Sync OrangeFox Sources!" && exit 1; }

# Change to the Source Directory
cd ~/OrangeFox/12.1

# Clone the theme if not already present
if [ ! -d bootable/recovery/gui/theme ]; then
git clone https://gitlab.com/OrangeFox/misc/theme.git || { echo "ERROR: Failed to Clone the OrangeFox Theme!" && exit 1; }
fi

# Clone Trees
DT_PATH="/device/ulefone/Power_Armor14_Pro
git clone https://github.com/DurkaFlurk/android_device_Power_Armor14_Pro.git $/device/ulefone/Power_Armor14_Pro || { echo "ERROR: Failed to Clone the Device Trees!" && exit 1; }

# Clone Additional Dependencies (Specified by the user)
for dep in "${DEPS[@]}"; do
	rm -rf $(echo $dep | sed 's/ -b / /g')
	git clone --depth=1 --single-branch $dep

# Magisk
if [[ $OF_USE_LATEST_MAGISK = "true" || $OF_USE_LATEST_MAGISK = "1" ]]; then
	echo "Downloading the Latest Release of Magisk..."
	LATEST_MAGISK_URL="$(curl -sL https://api.github.com/repos/topjohnwu/Magisk/releases/latest | jq -r . | grep browser_download_url | grep Magisk- | cut -d : -f 2,3 | sed 's/"//g')"
	mkdir -p ~/Magisk
	cd ~/Magisk
	aria2c $LATEST_MAGISK_URL 2>&1 || wget $LATEST_MAGISK_URL 2>&1
	echo "Magisk Downloaded Successfully"
	echo "Renaming .apk to .zip ..."
	#rename 's/.apk/.zip/' Magisk*
	mv $("ls" Magisk*.apk) $("ls" Magisk*.apk | sed 's/.apk/.zip/g')
	cd $SYNC_PATH >/dev/null
	echo "Done!"
fi

# Exit
exit 0
