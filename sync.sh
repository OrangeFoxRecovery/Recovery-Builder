#!/bin/bash

set -e
set -x

repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-19.0
git clone https://github.com/Azure-007/local_manifests.git --depth 1 -b main .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
