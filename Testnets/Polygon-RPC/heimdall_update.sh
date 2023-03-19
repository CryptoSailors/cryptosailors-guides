#!/bin/bash

echo -e '\n\e[42mUpgrade heimdall\e[0m\n' && sleep 1
source .bash_profile
sudo systemctl stop bor
sudo systemctl stop heimdalld
cd heimdall
git pull
latestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
git checkout $latestTag
make install

echo -e '\n\e[42mCheck heimdall version\e[0m\n' && sleep 1
heimdalld version && sleep 3
sudo systemctl start heimdalld 

echo -e '\n\e[42mBor will be started after 120sec. Please wait...\e[0m\n' && sleep 120
sudo systemctl start bor
