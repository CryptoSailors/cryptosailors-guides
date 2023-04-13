#!/bin/bash

echo -e '\n\e[42mUpgrade lighthouse Beacone\e[0m\n' && sleep 1
source $HOME/.cargo/env
cd lighthouse
git pull
latestTag=$(curl -s https://api.github.com/repos/sigp/lighthouse/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make

echo -e '\n\e[42mCheck lighthouse version and start a beacone\e[0m\n' && sleep 1
cd ~
./.cargo/bin/lighthouse --version
sudo systemctl restart lighthouse
sudo journalctl -u lighthouse -f -n 100
