#!/bin/bash

# Do not allow curl
curl_check=$(grep 'curl ' $CONFIG | wc -l)
if [[ $curl_check -gt 0 ]]; then
    echo -e "Please dont use \'curl\' in $CONFIG".
    exit 1
fi
