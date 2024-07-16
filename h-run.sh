#!/usr/bin/env bash

killall -9 spectre-miner > /dev/null 2>&1
. h-manifest.conf

CUSTOM_LOG_BASEDIR=`dirname "$CUSTOM_LOG_BASENAME"`
[[ ! -d $CUSTOM_LOG_BASEDIR ]] && mkdir -p $CUSTOM_LOG_BASEDIR

./spectre-miner $(< $CUSTOM_CONFIG_FILENAME) $@ 2>&1 | tee -a ${CUSTOM_LOG_BASENAME}.log