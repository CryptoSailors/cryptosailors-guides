#!/bin/bash

echo -e '\n\e[42mUpgrade Bor\e[0m\n' && sleep 1
source .bash_profile
sudo systemctl stop bor
cd bor
git pull
latestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
git checkout $latestTag
make

echo -e '\n\e[42mCheck bor version\e[0m\n' && sleep 1
bor version && sleep 3
sudo systemctl start bor && journalctl -u bor -f -n 100
