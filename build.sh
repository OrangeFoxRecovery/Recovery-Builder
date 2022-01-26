#!/bin/bash

set -e
set -x

source build/envsetup.sh
lunch lineage_raphael-userdebug
make bacon -j$(nproc --all)
