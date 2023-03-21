#!/bin/bash

echo -e '\n\e[42mUpgrade Bor\e[0m\n' && sleep 1
source .bash_profile
sudo systemctl stop bor
cd bor
git pull
latestTag=$(curl -s https://api.github.com/repos/maticnetwork/bor/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make

echo -e '\n\e[42mCheck bor version\e[0m\n' && sleep 1
bor version && sleep 3
sudo systemctl start bor && journalctl -u bor -f -n 100
