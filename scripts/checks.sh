#!/bin/bash

# Telegram
tg_check=$(grep 'TG' $CONFIG | wc -l)
if [[ $tg_check -gt 0 ]]; then
    echo "ERROR - You Cannot Set *TG* Vars in your $CONFIG"
    exit 1
fi

# Do not allow curl
curl_check=$(grep 'curl ' $CONFIG | wc -l)
if [[ $curl_check -gt 0 ]]; then
    echo -e "Please dont use \'curl\' in $CONFIG".
    exit 1
fi
