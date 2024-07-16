#!/usr/bin/env bash

. /hive/miners/custom/$CUSTOM_NAME/h-manifest.conf
stats_raw=`curl -s 'http://localhost:5959/'`

if [[ $? -ne 0 || -z $stats_raw ]]; then
    echo -e "${YELLOW}Failed to read $miner from localhost:5959${NOCOLOR}"
else
    local temp=`/hive/sbin/cpu-temp`

    HASHRATE=$(echo $stats_raw | jq -r '.hashrate')
    ACCEPTED=$(echo $stats_raw | jq -r '.accepted')
    REJECTED=$(echo $stats_raw | jq -r '.rejected')
    UPTIME=$(echo $stats_raw | jq -r '.uptime')
    VERSION=$(echo $stats_raw | jq -r '.version')

    local khs=$(bc <<< "scale=3; ${HASHRATE}/1000")
    stats=$(jq -nc \
            --argjson hash $HASHRATE \
            --arg units "hs" \
            --argjson acc $ACCEPTED \
            --argjson rej $REJECTED \
            --argjson uptime $UPTIME \
            --arg ver $VERSION \
            --argjson temp $temp \
            --arg algo "SPECTREX" \
        '{hs: [$hash], hs_units: $units, ar: [$acc, $rej], uptime: $uptime, ver: $ver, temp: [$temp], algo: $algo}')
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"