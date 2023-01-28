<p align="center">
 <img src="https://i.imgur.com/HvrpANG.jpg"/></a>
</p>

# Bitcanna DevNet node installation guide.

## 1. Requirements.
#### Official 
- 4vCPUs (8vCPUs is recommened)
- 8 GB RAM
- 200GB - 300GB SSD Disk space per year (NVMe disks are recommended)
- 400 Mbit/s bandwith
#### Our Recommendations
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
CHAIN_ID=bitcanna-dev-1
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.profile
source $HOME/.profile
```
## 3. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 4. Install a node
Make sure that you are installing the [latest release](https://github.com/BitCannaGlobal/bcna/releases/latest). In this guide we use release `v1.5.3`
```
git clone https://github.com/BitCannaGlobal/bcna
cd bcna
git checkout v1.5.3
make install
```
```
cd ~
```
```
bcnad init <your_node_name_here> --chain-id=$CHAIN_ID
```
```
wget -O $HOME/.bcna/config/genesis.json "https://raw.githubusercontent.com/bitcannaglobal/bcna/main/devnets/bitcanna-dev-1/genesis.json"
```

## 5. Node Configuration
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0stake\"/;" ~/.bcna/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.bcna/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.bcna/config/config.toml
peers="08b21d835cf7386387c5ec0611fd77087f772b83@88.99.15.74:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.bcna/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.bcna/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.bcna/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.bcna/config/config.toml
```
```
wget -O $HOME/.bcna/config/addrbook.json https://raw.githubusercontent.com/CryptoSailors/cryptosailors-guides/main/BitcannaDevnet/addrbook.json
```
### Choose Sync Mode (Snapshot or State-Sync)
#### Snapshot
```
wget http://88.99.15.74:8000/bcnadata.tar.gz
```
```
tar -C $HOME/ -zxvf bcnadata.tar.gz --strip-components 1
```
```
rm -rf bcnadata.tar.gz
```
#### State-Sync
```
peers="08b21d835cf7386387c5ec0611fd77087f772b83@88.99.15.74:26656" 
sed -i.bak -e  "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.bcna/config/config.toml
```
```
SNAP_RPC=88.99.15.74:26657
```
```
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
```
```
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH
```
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" ~/.bcna/config/config.toml
```
#### Optional (You can skip this step)
If you run more than one cosmos node, you can change a ports using the comands bellow.
```
COSMOS_PORT=12
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.profile
source $HOME/.profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/.bcna/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/.bcna/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/.bcna/config/client.toml
```
#### Create a systemd file for bcna node
if you run from root, insert `USER=root` in systemd configuration.
```
sudo tee /etc/systemd/system/bcnad.service > /dev/null <<EOF
[Unit]
Description=Bcna Node
After=network-online.target

[Service]
User=<Insert_your_User>
ExecStart=$(which bcnad) start
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
sudo systemctl start bcnad
sudo systemctl enable bcnad
sudo journalctl -u bcnad -f -n 100
```
Wait until your node is fully synchronized. To check your synchronization status use command bellow.
```
bcnad status 2>&1 | jq .SyncInfo
```
- If node show `false` - that means that you are synched and can contine. 
- If node show `true` - that means that you are **NOT** synched and should wait.

## 7. Create your wallet.
The comment bellow will give you a wallet address and mnemonic phrase, which you should save on safe place.
```
bcnad keys add wallet
```
Get tokens in the official Discord Server #devnet-faucet channel, type !claim <wallet_address>

## 8. Сreate own validator
```
bcnad tx staking create-validator \
--amount=<Number of tokens>ubcna \
--broadcast-mode=block \
--pubkey=$(bcnad tendermint show-validator) \
--moniker=<YOUR MONIKER> \
--commission-rate="0.1" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.1" \
--min-self-delegation="1" \
--from=<WALLETNAME> \
--chain-id=bitcanna-dev-1 \
--gas=auto -y
```
Finaly you should see your validator in [Block Explorer](https://testnet.ping.pub/bitcanna/staking) on Active or Inactive set.

## 9. Deleting a node
```
sudo systemctl stop bcnad && \
sudo systemctl disable bcnad && \
rm /etc/systemd/system/bcnad.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf bcna && \
rm -rf .bcna && \
rm -rf $(which bcnad)
```
#
**🐬Address book:** `wget -O $HOME/.bcna/config/addrbook.json https://raw.githubusercontent.com/CryptoSailors/cryptosailors-guides/main/BitcannaDevnet/addrbook.json`

**🐬Public RPC:** 88.99.15.74:26657

**🐬Peer:** `08b21d835cf7386387c5ec0611fd77087f772b83@88.99.15.74:26656`

**🐬API:** 88.99.15.74:1317

**🐬gRPC:** 88.99.15.74:9090

**🐬SnapShot:** http://88.99.15.74:8000/bcnadata.tar.gz

#
👉[Webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/jyaG8jhZGu)

👉[WebSite](https://www.bitcanna.io/)

👉[Official guide](https://docs.bitcanna.io/)

👉[Bitcanna Explorer](https://explorer.bitcanna.io/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 

oxes#8647 / @oxess
