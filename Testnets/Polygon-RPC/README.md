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
git clone https://github.com/maticnetwork/heimdall
cd heimdall
git checkout $RELEASE
make install
```
```
cd ~
```
## 5. Configure Heimdall node
```
heimdalld init --chain=mumbai
```
```
COSMOS_PORT=10
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.profile
source $HOME/.profile
```
```
SEEDS="4cd60c1d76e44b05f7dfd8bab3f447b119e87042@54.147.31.250:26656,b18bbe1f3d8576f4b73d9b18976e71c65e839149@34.226.134.117:26656"
```
In command bellow insert your ETH goeril url started from http://:PRORT
```
ETH_GOERLI_RPC="http://YOUR_RPC_URL:PORT"
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/.heimdalld/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/.heimdalld/config/app.toml
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $HOME/.heimdalld/config/config.toml
sed -i.bak -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.heimdalld/config/config.toml
sed -i.bak -e "s/^max_open_connections *=.*/max_open_connections = \"100\"/" $HOME/.heimdalld/config/config.toml
sed -i.bak -e "s/^eth_rpc_url *=.*/eth_rpc_url = \"$ETH_GOERLI_RPC\"/" $HOME/.heimdalld/config/heimdall-config.toml
```
## 6. Create a systemd, download latest snapshot and launch heimdall
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
