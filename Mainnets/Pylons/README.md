<p align="center">
 <img src=""/></a>
</p>

# Pylons mainnet node guide installation.

## 1. Requirements.

#### Official 
- 4 CPU or more
- 8 GB RAM
- 150 GB SSD
  
#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Create a user
```
sudo adduser pylons
```
```
sudo usermod -aG sudo pylons
sudo usermod -aG systemd-journal pylons
```
```
sudo su - pylons
```
## 3. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
```
MONIKER=YOUR_MONIKER
```
```
CHAIN_ID=pylons-mainnet-1
export FOLDER=.pylons
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

#### Install Node.Js
```
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## 4. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 5. Install a node
```
git clone https://github.com/Pylons-tech/pylons
cd pylons
git fetch --all
latestTag=$(curl -s https://api.github.com/repos/Pylons-tech/pylons/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make install
```
```
cd ~
```
```
pylonsd init $MONIKER --chain-id=$CHAIN_ID
```
```
curl https://anode.team/Pylons/main/genesis.json > ~/$FOLDER/config/genesis.json
curl https://anode.team/Pylons/main/addrbook.json > ~/$FOLDER/config/addrbook.json
```

## 6. Node Configuration
```
SEEDS="e711b6631c3e5bb2f6c389cbc5d422912b05316b@seed.ppnv.space:28256"
PEERS="f9b5f8f0009e18b956a87580cd0e7e765ed9e3f3@rpc.pylons.ppnv.space:12656,"
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$FOLDER/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0ubedrock\"|" $HOME/$FOLDER/config/app.toml
sed -i 's|indexer =.*|indexer = "'null'"|g' $HOME/$FOLDER/config/config.toml
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/$FOLDER/config/app.toml
```

#### Optional (You can skip this step)
If you run more than one cosmos node, you can change a ports using the comands bellow.
```
COSMOS_PORT=13
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/$FOLDER/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/$FOLDER/config/client.toml
```

#### Create a systemd file for pylons node
```
sudo tee /etc/systemd/system/pylonsd.service > /dev/null <<EOF
[Unit]
Description=Pylons Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which pylonsd) start
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target

EOF
```

#### Download the latest snapshot
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" ~/.pylons/config/config.toml
mv $HOME/$FOLDER/priv_validator_state.json.backup $HOME/$FOLDER/data/priv_validator_state.json
rm -rf ~/.pylons/data
pylonsd tendermint unsafe-reset-all --home ~/.pylons/
SNAP_NAME=$(curl -s https://ss.pylons.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss.pylons.nodestake.top/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.pylons
```
                                                        
## 7. Start synchronization
```
sudo systemctl daemon-reload
sudo systemctl start pylonsd
sudo systemctl enable pylonsd
sudo journalctl -u pylonsd -f -n 100
```
Wait until your node is fully synchronized. To check your synchronization status use command bellow.
```
agd status 2>&1 | jq .SyncInfo
```
- If node show `false` - that means that you are synched and can contine. 
- If node show `true` - that means that you are **NOT** synched and should wait.

## 8. Create your wallet.
The comment bellow will give you a wallet address and mnemonic phrase, which you should save on safe place.
```
pylonsd keys add wallet
```

## 9. Сreate own validator
```
pylonsd tx staking create-validator \
--amount 0ubedrock \
--pubkey $(pylonsd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id $CHAIN_ID \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.1 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0ubedrock \
-y

```
Finaly you should see your validator in [Block Explorer](https://agoric.explorers.guru/) on Active or Inactive set.

## 10. Deleting a node
```
sudo systemctl stop pylonsd
sudo rm -rf $FOLDER
sudo rm -rf pylons
sudo rm -rf /go/bin/pylonsd
sudo rm -rf /etc/systemd/system/pylonsd.service
```

## 11. Upgrade your node
```
cd pylons
git fetch --all
latestTag=$(curl -s https://api.github.com/repos/Pylons-tech/pylons/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make install
```

#
👉[Webtropia](https://bit.ly/45KaUj4) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[WebSite](https://www.pylons.tech/home/)

👉[Official Github](https://github.com/Pylons-tech)

👉[Pylons Explorer](https://pylons.explorers.guru/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
