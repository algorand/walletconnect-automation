#!/bin/bash

SCRIPT_PATH=$(dirname "${0}")

BUILD_TIME=$(date +%s)

docker build \
    -t walletconnect/relay-server:latest \
    -t walletconnect/relay-server:latest-java \
    -t walletconnect/relay-server:${BUILD_TIME}-java \
    - < ${SCRIPT_PATH}/../docker/Dockerfile
