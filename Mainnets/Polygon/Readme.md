<p align="center">
 <img src="https://i.postimg.cc/RZfxLxXb/Polygon-logo-resized-jpeg.jpg"/></a>
</p>

# Polygon mainnet node guide installation.

## 1. Requirements.
#### Official 
- 8 CPU
- 32 GB RAM
- 4 TB SSD
#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://www.webtropia.com/?kwk=255074042020228216158042)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Server preparation.

Create a user
```
sudo adduser polygon
sudo usermod -aG sudo polygon
sudo usermod -aG systemd-journal polygon
sudo su - polygon
```
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
## 3. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 4. Install a Heimdall
Checek the [latest release](https://github.com/maticnetwork/heimdall/tags).
```
git clone https://github.com/maticnetwork/heimdall
cd heimdall
latestTag=$(curl -s https://api.github.com/repos/maticnetwork/heimdall/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make install
heimdalld version
cd ~
```
## 5. Configure Heimdall node
```
heimdalld init --chain=mainnet
```
```
SEEDS="1500161dd491b67fb1ac81868952be49e2509c9f@52.78.36.216:26656,dd4a3f1750af5765266231b9d8ac764599921736@3.36.224.80:26656,8ea4f592ad6cc38d7532aff418d1fb97052463af@34.240.245.39:26656,e772e1fb8c3492a9570a377a5eafdb1dc53cd778@54.194.245.5:26656,6726b826df45ac8e9afb4bdb2469c7771bd797f1@52.209.21.164:26656"
```
Insert your ETH RPC Url in `YOUR_ETH_LINK`
```
ETH_RPC="YOUR_ETH_LINK"
```
```
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $HOME/.heimdalld/config/config.toml
sed -i.bak -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.heimdalld/config/config.toml
sed -i.bak -e "s/^max_open_connections *=.*/max_open_connections = \"100\"/" $HOME/.heimdalld/config/config.toml
sed -i.bak -e "s%^eth_rpc_url = \"http://localhost:9545\"%eth_rpc_url = \"${ETH_RPC}\"%" $HOME/.heimdalld/config/heimdall-config.toml
```

## 6. Create a systemd, download latest snapshot.
```
sudo tee /etc/systemd/system/heimdalld.service > /dev/null <<EOF
[Unit]
  Description=heimdalld
  StartLimitIntervalSec=500
  StartLimitBurst=5

[Service]
  Restart=on-failure
  RestartSec=5s
  ExecStart=$(which heimdalld) start --rest-server --chain=mainnet
  Type=simple
  User=$USER

[Install]
  WantedBy=multi-user.target
EOF
```
Download latest heimdall-mumbai [snapshot](https://snapshots.polygon.technology/). I recomend use `screen` or `tmux`, becouse downloading the snapshot will take about 20min.
```
curl -L https://snapshot-download.polygon.technology/snapdown.sh | bash -s -- --network mainnet --client heimdall --extract-dir $HOME/.heimdalld/data --validate-checksum true
```
## 7. Start a heimdall node
```
sudo systemctl daemon-reload
sudo systemctl enable heimdalld
sudo systemctl start heimdalld
sudo journalctl -u heimdalld -f -n 100
```
#### Before to proceed step 8, make sure that your heimdall node is fully synched. Other wise your bor service will run with issues.

Checek your synch with command:
```
curl -s localhost:26657/status
```
You will get somthing like this:
```
 },
    "sync_info": {
      "latest_block_hash": "8158653F44D9713FCF919215C2AAD5AFB10DAC541DED85BED203E0E3C788F8B7",
      "latest_app_hash": "FAB2E0808DCA67D1409D7FD751875496C566659D5D7F9F357E97BEECA72421E5",
      "latest_block_height": "15198037",
      "latest_block_time": "2023-02-22T15:28:41.607754234Z",
      "catching_up": true
},
```
 - if you get `true`  - means that you still synch
 - if you get `false` - means you are synched and can continue.

## 8. Install a Bor
Checek the [latest release](https://github.com/maticnetwork/bor/tags).
```
git clone https://github.com/maticnetwork/bor
cd bor
latestTag=$(curl -s https://api.github.com/repos/maticnetwork/bor/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make bor
bor version
```

## 9. Configure your bor node
```
cd ~
mkdir .bor && cd .bor && mkdir data && cd data && mkdir bor
cd ~
cd .bor
wget https://raw.githubusercontent.com/CryptoSailors/cryptosailors-guides/main/Mainnets/Polygon/config.toml
```
**Create a systemd file for bor**
```
cd ~
sudo tee /etc/systemd/system/bor.service > /dev/null <<EOF

[Unit]
  Description=bor
  StartLimitIntervalSec=500
  StartLimitBurst=5

[Service]
  Restart=on-failure
  RestartSec=5s
  ExecStart=$(which bor) server -config /home/polygon/.bor/config.toml
  Type=simple
  User=$USER
  KillSignal=SIGINT
  TimeoutStopSec=120

[Install]
  WantedBy=multi-user.target
  
EOF
```
## 10. Download the lates snapshot and launch a node.
Download latest bor-mainnet [snapshot](https://snapshots.polygon.technology/). I recomend use `screen` or `tmux`, becouse downloading the snapshot will take about 5h.
```
curl -L https://snapshot-download.polygon.technology/snapdown.sh | bash -s -- --network mainnet --client bor --extract-dir $HOME/.bor/data/bor/chaindata --validate-checksum true
```
Start a bor service
```
sudo systemctl daemon-reload
sudo systemctl enable bor
sudo systemctl start bor
sudo journalctl -u bor -f -n 100
```
You can check your synch:
```
curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "eth_syncing", "params":[]}' localhost:8573
```
- if they show `false` you are synched.

## 11 Your RPC url are:
- `http://YOUR_IP:8573`
- `ws://YOUR_IP:8915`

## 12. Update your bor node

#### Bor Manual update
```
source .bash_profile
sudo systemctl stop bor
cd bor
git pull
latestTag=$(curl -s https://api.github.com/repos/maticnetwork/bor/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make
bor version
```
```
sudo systemctl start bor && journalctl -u bor -f -n 100
```

## 13. Update your heimdall node

#### Heimdall Manual update
```
source .bash_profile
sudo systemctl stop bor
sudo systemctl stop heimdalld
cd heimdall
git pull
latestTag=$(curl -s https://api.github.com/repos/maticnetwork/heimdall/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make install
heimdalld version
```
```
sudo systemctl start heimdalld 
sudo systemctl start bor
sudo journalctl -u heimdalld -f -n 100
```
#

👉[Webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/0xpolygon)

👉[Official guide](https://wiki.polygon.technology/)

👉[Polygon Explorer](https://polygonscan.com/)

👉[Heimdall Github](https://github.com/maticnetwork/heimdall/tags)

👉[Bor Github](https://github.com/maticnetwork/bor/tags)

👉[Snapshots](https://snapshots.polygon.technology/) 

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
