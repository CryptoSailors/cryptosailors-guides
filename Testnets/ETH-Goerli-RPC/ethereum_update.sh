#!/bin/bash

echo -e '\n\e[42mUpgrade Ethereum Node\e[0m\n' && sleep 1
source .bash_profile
cd go-ethereum
git pull
latestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
git checkout $latestTag
make

echo -e '\n\e[42mCheck Ethereum version\e[0m\n' && sleep 1
sudo mv build/bin/geth /usr/bin/
geth version
sudo systemctl restart geth 
sudo journalctl -u geth -f -n 100
