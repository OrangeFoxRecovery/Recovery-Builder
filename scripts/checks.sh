#!/bin/bash

# Telegram
tg_check=$(grep 'TG' "$CONFIG" | wc -l)

# Do not allow curl
curl_check=$(grep 'curl ' "$CONFIG" | wc -l)

[[ "$tg_check" -gt "0" ]] && {
    echo "ERROR - Cannot set *TG* variables in $CONFIG"
    exit 1
}

[[ "$curl_check" -gt "0" ]] && {
    echo "Please do not use 'curl' in $CONFIG"
    exit 1
}
