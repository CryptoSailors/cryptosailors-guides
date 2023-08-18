#!/bin/bash

echo -e '\n\e[42mUpgrade fantom Node\e[0m\n' && sleep 2
source .bash_profile
cd go-opera
git pull
latestTag=$(curl -s https://api.github.com/repos/Fantom-foundation/go-opera/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make
sudo mv $HOME/go-opera/build/opera /usr/bin/


echo -e '\n\e[42mCheck Fantom version\e[0m\n' && sleep 2
opera version

echo -e '\n\e[42mRestart and check Fantom service\e[0m\n' && sleep 5
sudo systemctl restart fantom
sudo journalctl -u fantom -f -n 100
