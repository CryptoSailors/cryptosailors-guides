<p align="center">
 <img src="https://i.postimg.cc/CxsxpvY3/banner.jpg"/></a>
</p>

# Lava testnet node guide installation.

## 1. Requirements.
#### Official 
- 4 CPU
- 8 GB RAM
- 100 GB SSD
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
```
CHAIN_ID=lava-testnet-1
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.profile
source $HOME/.profile
```
## 3. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 4. Install a node
Make sure that you are installing the [latest release](https://github.com/lavanet/lava/tags). In this guide we use release `v0.5.2`
```
git clone https://github.com/lavanet/lava
cd lava
git checkout v0.5.2 
make install
```
```
cd ~
```
```
lavad init <your_node_name_here> --chain-id=$CHAIN_ID
```
```
git clone https://github.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T.git
mv GHFkqmTzpdNLDd6T/testnet-1/genesis_json/genesis.json .lava/config
```

## 5. Node Configuration
```
sed -i 's|seeds =.*|seeds = "3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"|g' $HOME/.lava/config/config.toml
sed -i 's/create_empty_blocks = .*/create_empty_blocks = true/g' ~/.lava/config/config.toml
sed -i 's/create_empty_blocks_interval = ".*s"/create_empty_blocks_interval = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_propose = ".*s"/timeout_propose = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_commit = ".*s"/timeout_commit = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_broadcast_tx_commit = ".*s"/timeout_broadcast_tx_commit = "601s"/g' ~/.lava/config/config.toml
```
```
wget -O $HOME/.lava/config/addrbook.json https://github.com/CryptoSailors/cryptosailors-guides/blob/main/Testnets/Lava/addrbook.json
```
#### Setup the latest Snapshot on your node
```
wget http://88.99.33.248:8000/lavadata.tar.gz
```
```
tar -C $HOME/ -zxvf lavadata.tar.gz --strip-components 1
```
```
rm -rf lavadata.tar.gz
```
#### Optional (You can skip this step)
If you run more than one cosmos node, you can change a ports using the comands bellow.
```
COSMOS_PORT=12
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.profile
source $HOME/.profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/.lava/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/.lava/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/.lava/config/client.toml
```

#### Create a systemd file for lava node
if you run from root, insert `USER=root` in systemd configuration.
```
sudo tee /etc/systemd/system/lavad.service > /dev/null <<EOF
[Unit]
Description=Lava Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which lavad) start
Restart=always
RestartSec=180
LimitNOFILE=infinity
LimitNPROC=infinity

[Install]
WantedBy=multi-user.target
EOF
```
                                                        
## 6. Start synchronization
```
sudo systemctl daemon-reload
sudo systemctl start lavad
sudo systemctl enable lavad
sudo journalctl -u lavad -f -n 100
```
Wait until your node is fully synchronized. To check your synchronization status use command bellow.
```
lavad status 2>&1 | jq .SyncInfo
```
- If node show `false` - that means that you are synched and can contine. 
- If node show `true` - that means that you are **NOT** synched and should wait.

## 7. Create your wallet and claim test tokens.
The comment bellow will give you a wallet address and mnemonic phrase, which you should save on safe place.
```
lavad keys add wallet
```
Ask a test tokens sombody in [Discord](https://discord.gg/BBgprSw2vn). Becouse currently faucet work with issue.
## 8. Сreate own validator
```
lavad tx staking create-validator \
    --amount="10000ulava" \
    --pubkey=$(lavad tendermint show-validator --home "$HOME/.lava/") \
    --moniker="Your_Validator_Name" \
    --chain-id=lava-testnet-1 \
    --commission-rate="0.10" \
    --commission-max-rate="0.20" \
    --commission-max-change-rate="0.01" \
    --min-self-delegation="10000" \
    --gas="auto" \
    --gas-adjustment "1.5" \
    --gas-prices="0.05ulava" \
    --home "$HOME/.lava/" \
    --from=wallet
```
Finaly you should see your validator in [Block Explorer](https://lava.explorers.guru/) on Active or Inactive set.

## 9. Deleting a node
```
sudo systemctl stop lavad
sudo rm -rf .lava
sudo rm -rf lava
sudo rm -rf /go/bin/lavad
sudo rm -rf /etc/systemd/system/lavad.service
sudo rm -rf GHFkqmTzpdNLDd6T
```
#
**🐬Address book:** `wget -O $HOME/.lava/config/addrbook.json https://raw.githubusercontent.com/CryptoSailors/cryptosailors-guides/main/Lava/addrbook.json`

**🐬Public RPC:** http://88.99.33.248:26657/

**🐬Peer:** `d9703df8c0e5eef6c0766217d611a13ed6ee8d95@88.99.33.248:26656`

**🐬API:** http://88.99.33.248:1317/

**🐬gRPC:** http://88.99.33.248:9090/

**🐬SnapShot:** http://88.99.33.248:8000/lavadata.tar.gz
#
👉[Webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/BBgprSw2vn)

👉[WebSite](https://www.lavanet.xyz/)

👉[Official guide](https://docs.lavanet.xyz/)

👉[Lava Explorer](https://lava.explorers.guru/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor

oxes#8647 / @oxess
