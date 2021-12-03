#!/bin/bash

SCRIPT_PATH=$(dirname "${0}")
CWD=`pwd`
TMPDIR=$(mktemp -d /tmp/foo.XXXXXX)

cd $TMPDIR

git clone https://github.com/WalletConnect/walletconnect-monorepo.git
cd walletconnect-monorepo
make build-img-relay

rm -rf $TMPDIR
