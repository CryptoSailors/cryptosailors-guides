<p align="center">
 <img src="https://i.postimg.cc/9QBPqDyW/1-a-Ck-Sgk39-Uhfb-1wzg-Ty5-Pg.jpg"/></a>
</p>

# In this Guide we will install a Uptick Testnet Node

## 1. Requirements.
Official 
- 4 CPU
- 8 GB RAM
- 200 GB SSD
- #### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://www.webtropia.com/?kwk=255074042020228216158042)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake snapd lz4 -y
```
```
CHAIN_ID=origin_1170-1
export FOLDER=.uptickd
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
Install [GO according this instruction](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22)

## 3. Node installation.
```
git clone https://github.com/UptickNetwork/uptick
cd uptick
git checkout v0.2.7-gon
make install
cd ~
```
Change `<moniker-name>` on your name
```
uptickd init <moniker-name> --chain-id=$CHAIN_ID
```
Download the genis.json file.
```
wget -O $HOME/$FOLDER/config/genesis.json "https://raw.githubusercontent.com/UptickNetwork/uptick-testnet/main/origin_1170-1/config/genesis.json"
```

## 4. Configure our node
```
PEERS=4e9c4865b96e4675da9322d50e1ec439161d56ea@54.179.233.10:26656
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
Create a systemd file for uptick.
```
sudo tee /etc/systemd/system/uptickd.service > /dev/null <<EOF

[Unit]
Description=Uptick
After=network-online.target

[Service]
User=$USER
ExecStart=$(which uptickd) start
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]

WantedBy=multi-user.target
EOF
```

## 5. This step is optional needed only, if you run more than one node on your machine.
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

## 6. Download latest Snapshot
We will you snapshot from [NodeStake validator](https://nodestake.top/uptick)
```
cp $HOME/$FOLDER/data/priv_validator_state.json $HOME/$FOLDER/priv_validator_state.json.backup
rm -rf $HOME/$FOLDER/data
```
```
SNAP_NAME=$(curl -s https://ss-t.uptick.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss-t.uptick.nodestake.top/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/$FOLDER
mv $HOME/$FOLDER/priv_validator_state.json.backup $HOME/$FOLDER/data/priv_validator_state.json
```

## 7. Start a node
```
sudo systemctl daemon-reload
sudo systemctl start uptickd
sudo systemctl enable uptickd
sudo journalctl -u uptickd -f -n 100
```
We are launchig a node from State Synch. Node need some time to catch up a peers. Press `CTRL+X,Y,Enter` to exit from the logs. To checke your synch launch command:
```
uptickd status 2>&1 | jq .SyncInfo
```
If the command gives out `true` - it means that synchronization is still in process
If the command gives `false` - then you are synchronized and you can start creating the validator.

## 8. Create your wallet.
The comment bellow will give you a wallet address and mnemonic phrase, which you should save on safe place.
```
uptickd keys add wallet
```
If you would like recover your wallet
```
uptickd keys add wallet --recover
```
Got to the [faucet](https://faucet.origin.uptick.network/) and claim test tokens.

Check your wallet balance
```
uptickd q bank balances <your-wallet-address>
```
## 9. Сreate own validator
```
uptickd tx staking create-validator \
  --amount 5000000000000000000auoc \
  --from wallet \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(uptickd tendermint show-validator) \
  --moniker<YOUR_NODE_MONIKER> \
  --chain-id $CHAIN_ID \
  --identity "" \
  --website="" \
  --details="" \
  --gas=auto
```
Finaly you should see your validator in [Block Explorer](https://gon.ping.pub/uptick%20origin/staking) on Active or Inactive set.

## 10. Backup your node
After successfully creating a validator, you must take care of `priv_validator_key.json`. Without it you will not be able to restore the validator. It can be found in the folder `.kyve/config`

## 11. Deleting a node
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

👉[Uptick Explorer](https://gon.ping.pub/uptick%20origin/staking)

👉[NodeStake snapshot](https://services.kjnodes.com/home/mainnet/uptick/snapshot)

👉[Uptick Github](https://nodestake.top/uptick)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 

Pavel-LV | C.Sailors#7698 / @SeaInvestor
