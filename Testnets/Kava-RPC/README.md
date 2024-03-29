<p align="center">
 <img src="https://i.postimg.cc/W3QtQdh9/Kava-logo.jpg"/></a>
</p>

# In this guide we will setup Kava RPC testnet node.

#### Flollowing parametrs:

- 4-CPU
- 8-GBRAM
- 600-GB SSD 

#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 1. Node Preparation
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
## 2. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 3. Install Kava node
First check the latest [Release](https://github.com/Kava-Labs/kava/tags) of kava node. In our example it is `0.25.0-alpha.0`
```
REALEASE=0.25.0-alpha.0
git clone https://github.com/Kava-Labs/kava
cd kava
git checkout $RELEASE
make install
```
```
cd ~
```
## 4. Init and configure our node.
```
kava init moniker --chain-id kava_2221-16000
```
```
wget -O genesis.json https://snapshots.polkachu.com/testnet-genesis/kava/genesis.json --inet4-only
sudo mv genesis.json ~/.kava/config
```
```
sed -i 's/seeds = ""/seeds = "ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:13956"/' ~/.kava/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025ukava;1000000000akava\"/" $HOME/.kava/config/app.toml
sed -i.bak -e "s/^pruning  *=.*/pruning  = \"custom\"/" $HOME/.kava/config/app.toml
sed -i.bak -e "s/^pruning-keep-recent  *=.*/pruning-keep-recent  = \"100\"/" $HOME/.kava/config/app.toml
sed -i.bak -e "s/^pruning-keep-every  *=.*/pruning-keep-every  = \"0\"/" $HOME/.kava/config/app.toml
sed -i.bak -e "s/^pruning-interval  *=.*/pruning-interval  = \"10\"/" $HOME/.kava/config/app.toml
```
We will launch our node from polkachu [snapshot](https://polkachu.com/testnets/kava/snapshots) 

## 5 Create a systemd file and launch our node
```
sudo tee <<EOF >/dev/null /etc/systemd/system/kava.service
[Unit]
Description=KAVA daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which kava) start
Restart=on-failure
RestartSec=3
LimitNOFILE=16384

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl enable kava
sudo systemctl daemon-reload
sudo systemctl start kava
sudo journalctl -u kava -f -n 100
```
#

👉[Webtropia](https://bit.ly/45KaUj4) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Kava Official guide](https://docs.kava.io/docs/participate/validator-node/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
