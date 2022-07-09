#!/bin/bash

# Source Vars
source "$CONFIG"

# Change to the Home Directory
cd ~ || exit

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="$TG_CHAT_ID" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Clone the Sync Repo
git clone "$FOX_SYNC"
cd sync || exit

# Setup Branch names
[[ "$FOX_BRANCH" = "fox_12.0" ]] && {
	echo "Warning! Using fox_12.1 instead of fox_12.0."
	echo ""
	FOX_BRANCH="fox_12.1"
} || [[ "$FOX_BRANCH" = "fox_8.0" ]] && {
	echo "Warning! Using fox_8.1 instead of fox_8.0."
	echo ""
	FOX_BRANCH="fox_8.1"
}

# Setup the Sync Branch
[[ -z "$SYNC_BRANCH" ]] && export SYNC_BRANCH=$(echo "$FOX_BRANCH" | cut -d_ -f2)

# Sync the Sources
./orangefox_sync.sh --branch "$SYNC_BRANCH" --path "$SYNC_PATH" || { echo "ERROR: Failed to Sync OrangeFox Sources!" && exit 1; }

# Change to the Source Directory
cd "$SYNC_PATH" || exit

# Clone the theme if not already present
[[ ! -d bootable/recovery/gui/theme ]] && git clone https://gitlab.com/OrangeFox/misc/theme.git bootable/recovery/gui/theme || { echo "ERROR: Failed to Clone the OrangeFox Theme!" && exit 1; }

# Clone the Commonsys repo, only for fox_9.0
[[ "$FOX_BRANCH" == "fox_9.0" ]] && git clone --depth=1 https://github.com/TeamWin/android_vendor_qcom_opensource_commonsys.git -b android-9.0 vendor/qcom/opensource/commonsys || { echo "WARNING: Failed to Clone the Commonsys Repo!"; }

# Clone Trees
git clone "$DT_LINK" "$DT_PATH" || { echo "ERROR: Failed to Clone the Device Trees!" && exit 1; }

# Clone Additional Dependencies (Specified by the user)
for dep in "${DEPS[@]}"; do
	rm -rf "$dep"
	git clone --depth=1 --single-branch "$dep"
done

# Magisk
[[ "$OF_USE_LATEST_MAGISK" == "true" ]] || [[ "$OF_USE_LATEST_MAGISK" == "1" ]] && {
	echo "Downloading the Latest Release of Magisk..."
	LATEST_MAGISK_URL="$(curl -sL https://api.github.com/repos/topjohnwu/Magisk/releases/latest | jq -r . | grep browser_download_url | grep Magisk- | cut -d : -f 2,3 | sed 's/"//g')"
	mkdir -p ~/Magisk
	cd ~/Magisk || exit
	aria2c "$LATEST_MAGISK_URL" 2>&1 || wget "$LATEST_MAGISK_URL" 2>&1
	echo "Magisk Downloaded Successfully"
	echo "Renaming .apk to .zip ..."
	#rename 's/.apk/.zip/' Magisk*
	mv "$(ls Magisk*.apk)" "$(ls Magisk*.apk | sed 's/.apk/.zip/g')"
	cd "$SYNC_PATH" >/dev/null || exit
	echo "Done!"
}

# Pick patches for fox_12.1
[[ "$FOX_BRANCH" == "fox_12.1" ]] && {
	git -C system/vold fetch https://gerrit.twrp.me/android_system_vold refs/changes/40/5540/7
	git -C system/vold cherry-pick FETCH_HEAD
}

# Exit
exit 0