<p align="center">
 <img src="https://i.postimg.cc/FRptCfdXh4/68fee74747073sdsd3a2f2f7062732e7477696d672e636f6d2f6578745f74775f766964656f5f7468756d622f313632333035313030.jpg"/></a>
</p>

# Polygon testnet node guide installation.

## 1. Requirements.
#### Official 
- 8 CPU
- 32 GB RAM
- 2000 GB SSD
#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://www.webtropia.com/?kwk=255074042020228216158042)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
## 3. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 4. Install a Heimdall
Make sure that you are installing the [latest release](https://github.com/maticnetwork/heimdall/tags). In this guide we use release `v0.3.0`
```
RELEASE=v0.3.0
```
```
git clone https://github.com/maticnetwork/heimdall
cd heimdall
git checkout $RELEASE
make install
heimdalld version
```
```
cd ~
```
## 5. Configure Heimdall node
```
heimdalld init --chain=mumbai
```
```
SEEDS="4cd60c1d76e44b05f7dfd8bab3f447b119e87042@54.147.31.250:26656,b18bbe1f3d8576f4b73d9b18976e71c65e839149@34.226.134.117:26656"
```
Insert your Goerli RPC Url in `YOUR_ETH_GOERLI_LINK`
```
ETH_GOERLI_RPC="YOUR_ETH_GOERLI_LINK"
```
```
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $HOME/.heimdalld/config/config.toml
sed -i.bak -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.heimdalld/config/config.toml
sed -i.bak -e "s/^max_open_connections *=.*/max_open_connections = \"100\"/" $HOME/.heimdalld/config/config.toml
sed -i.bak -e "s%^eth_rpc_url = \"http://localhost:9545\"%eth_rpc_url = \"${ETH_GOERLI_RPC}\"%" $HOME/.heimdalld/config/heimdall-config.toml
```
#### Optional. You can skip step bellow and continue from step 6. It only need, if you have other cosmos node on your server.
```
COSMOS_PORT=10
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.profile
source $HOME/.profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/.heimdalld/config/config.toml
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
  ExecStart=$(which heimdalld) start --rest-server
  Type=simple
  User=$USER

[Install]
  WantedBy=multi-user.target
EOF
```
Download latest heimdall-mumbai [snapshot](https://snapshots.polygon.technology/). I recomend use `screen` or `tmux`, becouse downloading the snapshot will take about 20min.
```
wget <snapshot-link-heimdall> -O - | tar -xzf - -C ~/.heimdalld/data/
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
curl -s localhost:10657/status
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
Make sure that you are installing the [latest release](https://github.com/maticnetwork/bor/tags). In this guide we use release `v0.3.3`
```
cd ~
RELEASE=v0.3.3
```
```
git clone https://github.com/maticnetwork/bor
cd bor
git checkout $RELEASE
make bor
bor version
```

## 9. Configure your bor node
```
cd ~
mkdir .bor && cd .bor && mkdir data 
wget https://raw.githubusercontent.com/CryptoSailors/cryptosailors-guides/main/Testnets/Polygon-RPC/config.toml
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
  ExecStart=$(which bor) server -config ~/.bor/config.toml
  Type=simple
  User=$USER
  KillSignal=SIGINT
  TimeoutStopSec=120

[Install]
  WantedBy=multi-user.target
  
EOF
```
## 10. Download the lates snapshot and launch a node.
Download latest bor-mumbai [snapshot](https://snapshots.polygon.technology/). I recomend use `screen` or `tmux`, becouse downloading the snapshot will take about 70min.
```
wget <snapshot-link-bor> -O - | tar -xzf - -C ~/.bor/data
```
Start a bor service
```
sudo systemctl daemon-reload
sudo systemctl enable bor
sudo systemctl start bor
sudo journalctl -u bor -f -n 100
```
#
👉[Webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/ps6B3yaMb7)

👉[WebSite](https://www.althea.net/)

👉[Official guide](https://github.com/althea-net/althea-chain-docs/blob/main/docs/testnet-3-launch.md)

👉[Althea Explorer](https://test.anode.team/althea)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
