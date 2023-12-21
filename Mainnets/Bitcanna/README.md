<p align="center">
 <img src="https://i.imgur.com/HvrpANG.jpg"/></a>
</p>

# Bitcanna Mainnet node installation guide.

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
CHAIN_ID=bitcanna-1
FOLDER=.bcna
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## 3. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 4. Install a node
Make sure that you are installing the [latest release](https://github.com/BitCannaGlobal/bcna/releases/latest). In this guide we use release `v1.6.3`
```
git clone https://github.com/BitCannaGlobal/bcna
cd bcna
git fetch --all
latestTag=$(curl -s https://api.github.com/repos/BitCannaGlobal/bcna/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make install
```
```
cd ~
```
```
bcnad init <your_node_name_here> --chain-id=$CHAIN_ID
```
```
wget -O $HOME/.bcna/config/genesis.json "https://raw.githubusercontent.com/BitCannaGlobal/bcna/main/genesis.json"
```

## 5. Node Configuration
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0stake\"/;" ~/$FOLDER/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/$FOLDER/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/$FOLDER/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"400f3d9e30b69e78a7fb891f60d76fa3c73f0ecc@bitcanna.rpc.kjnodes.com:14259\"|" $HOME/$FOLDER/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/$FOLDER/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/$FOLDER/config/config.toml
sed -i 's|indexer =.*|indexer = "'null'"|g' $HOME/$FOLDER/config/config.toml
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
  $HOME/$FOLDER/config/app.toml
```
#### Optional (You can skip this step)
If you run more than one cosmos node, you can change a ports using the comands bellow.
```
COSMOS_PORT=14
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/$FOLDER/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/$FOLDER/config/client.toml
```
## 6. Downloand a Snapshot
We will you snapshot from [kjnodes validator](https://services.kjnodes.com/mainnet/bitcanna/snapshot/)
```
cp $HOME/$FOLDER/data/priv_validator_state.json $HOME/$FOLDER/priv_validator_state.json.backup
rm -rf $HOME/$FOLDER/data
```
```
curl -L https://snapshots.kjnodes.com/bitcanna/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER
mv $HOME/$FOLDER/priv_validator_state.json.backup $HOME/$FOLDER/data/priv_validator_state.json
```
#### Create a systemd file for bcna node
if you run from root, insert `USER=root` in systemd configuration.
```
sudo tee /etc/systemd/system/bcnad.service > /dev/null <<EOF
[Unit]
Description=Bcna Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which bcnad) start
Restart=always
RestartSec=180
LimitNOFILE=infinity
LimitNPROC=infinity

[Install]
WantedBy=multi-user.target
EOF
```
                                                        
## 7. Start synchronization
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

## 8. Create your wallet.
The comment bellow will give you a wallet address and mnemonic phrase, which you should save on safe place.
```
bcnad keys add wallet
```
Get tokens in the [Osmosis App](https://app.osmosis.zone/)

## 9. Сreate own validator
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
--chain-id=bitcanna-1 \
--gas=auto -y
```
Finaly you should see your validator in [Block Explorer](https://explorer.bitcanna.io/validators) on Active or Inactive set.

## 10 Deleting a node
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
