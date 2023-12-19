<p align="center">
 <img src="https://i.postimg.cc/9QBPqDyW/1-a-Ck-Sgk39-Uhfb-1wzg-Ty5-Pg.jpg"/></a>
</p>

# Uptick Mainnet node installation guide.

## 1. Requirements.
#### Official 
- 4vCPUs (8vCPUs is recommened)
- 16 GB RAM
- 200GB (NVMe disks are recommended)
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
## 3. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 4. Install a node
Make sure that you are installing the [latest release](https://github.com/UptickNetwork/uptick/releases/latest). In this guide we use release `v0.2.11`
```
git clone https://github.com/UptickNetwork/uptick
cd uptick
git fetch --all
latestTag=$(curl -s https://api.github.com/repos/UptickNetwork/uptick/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make install
```
```
cd ~
```
```
CHAIN_ID=uptick_117-1
FOLDER=.uptickd
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
uptickd init <your_node_name_here> --chain-id=$CHAIN_ID
```
```
wget -O $HOME/$FOLDER/config/genesis.json "https://raw.githubusercontent.com/UptickNetwork/uptick-mainnet/master/uptick_117-1/genesis.json"
```

## 5. Node Configuration
```
PEERS="48e7e8ca23b636f124e70092f4ba93f98606f604@54.37.129.164:55056,ed8af2e21ca079d722dd2222d93c18d18373401c@65.109.94.225:26656,8ecd3260a19d2b112f6a84e0c091640744ec40c5@185.165.241.20:26656,8e924a598a06e29c9f84a0d68b6149f1524c1819@57.128.109.11:26656,f05733da50967e3955e11665b1901d36291dfaee@65.108.195.30:21656,038aca614e49ec4e5e3a06c875976a94c478cb09@65.108.195.29:21656,d9bfa29e0cf9c4ce0cc9c26d98e5d97228f93b0b@uptick.rpc.kjnodes.com:15656,90c0c03d27e5b4354bffb709d28340f2657ca1c7@138.201.121.185:26679"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$FOLDER/config/config.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/$FOLDER/config/config.toml
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
COSMOS_PORT=16
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/$FOLDER/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/$FOLDER/config/client.toml
```
#### Create a systemd file for uptick node

```
sudo tee /etc/systemd/system/uptickd.service > /dev/null <<EOF
[Unit]
Description=Uptick Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which uptickd) start
Restart=always
RestartSec=180
LimitNOFILE=infinity
LimitNPROC=infinity

[Install]
WantedBy=multi-user.target
EOF
```
## 7. Download latest Snapshot
We will you snapshot from [kjnodes validator](https://services.kjnodes.com/home/mainnet/uptick/snapshot)
```
cp $HOME/.uptickd/data/priv_validator_state.json $HOME/.uptickd/priv_validator_state.json.backup
rm -rf $HOME/.uptickd/data
```
```
curl -L https://snapshots.kjnodes.com/uptick/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.uptickd
mv $HOME/.uptickd/priv_validator_state.json.backup $HOME/.uptickd/data/priv_validator_state.json
```                                                        
## 6. Start synchronization
```
sudo systemctl daemon-reload
sudo systemctl start uptickd
sudo systemctl enable uptickd
sudo journalctl -u uptickd -f -n 100
```
Wait until your node is fully synchronized. To check your synchronization status use command bellow.
```
uptickd status 2>&1 | jq .SyncInfo
```
- If node show `false` - that means that you are synched and can contine. 
- If node show `true` - that means that you are **NOT** synched and should wait.

## 7. Create your wallet.
The comment bellow will give you a wallet address and mnemonic phrase, which you should save on safe place.
```
uptickd keys add wallet
```
If you would like recover your wallet
```
uptickd keys add wallet --recover
```

## 8. Сreate own validator
```
uptickd tx staking create-validator \
  --amount 5000000000000000000auptick \
  --from wallet \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(uptickd tendermint show-validator) \
  --moniker <YourMoniker> \
  --chain-id $CHAIN_ID \
  --gas=auto
```
Finaly you should see your validator in [Block Explorer](https://explorer.bitcanna.io/validators) on Active or Inactive set.

## 9. Deleting a node
```
sudo systemctl stop uptickd && \
sudo systemctl disable uptickd && \
rm /etc/systemd/system/uptickd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf uptick && \
rm -rf $FOLDER && \
rm -rf $(which uptickd)
```

#
👉[Webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/jyaG8jhZGu)

👉[WebSite](https://www.uptick.network/)

👉[Official guide](https://docs.uptick.network/)

👉[Uptick Explorer](https://uptick.explorers.guru/)

👉[Kjnodes snapshot](https://services.kjnodes.com/home/mainnet/uptick/snapshot)

👉[Uptick Github](https://github.com/UptickNetwork/uptick)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 

Pavel-LV | C.Sailors#7698 / @SeaInvestor
