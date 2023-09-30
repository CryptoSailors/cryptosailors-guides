<p align="center">
 <img src="https://i.postimg.cc/4dRpshzT/Agoricjpg.jpg"/></a>
</p>

# Agoric mainnet node guide installation.

## 1. Requirements.

#### Official 
- 4 CPU or more
- 16 GB RAM
- 500 GB SSD
  
#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Server preparation.
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
CHAIN_ID=agoric-3
export FOLDER=.agoric
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

#### Install Node.Js
```
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```
#### Update NPM to latest version

```
sudo npm install -g npm@latest -g expo-cli --unsafe-perm
```

#### Yarn installation
```
sudo chown -R $(whoami) /usr/local/bin
npm install --global yarn -g expo-cli --unsafe-perm
```

## 3. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 4. Install a node
```
git clone https://github.com/Agoric/agoric-sdk
cd agoric-sdk
git fetch --all
latestTag=$(curl -s https://api.github.com/repos/Agoric/agoric-sdk/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
yarn install 
yarn build
(cd packages/cosmic-swingset && make)
```
```
cd ~
```
```
agd init $MONIKER --chain-id=$CHAIN_ID
```
```
curl -Ls https://snapshots.kjnodes.com/agoric/genesis.json > $HOME/$FOLDER/config/genesis.json
curl -Ls https://snapshots.kjnodes.com/agoric/addrbook.json > $HOME/$FOLDER/config/addrbook.json
```

## 5. Node Configuration
```
sed -i -e "s|^seeds *=.*|seeds = \"400f3d9e30b69e78a7fb891f60d76fa3c73f0ecc@agoric.rpc.kjnodes.com:12759\"|" $HOME/$FOLDER/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025ubld\"|" $HOME/$FOLDER/config/app.toml
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
COSMOS_PORT=11
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/$FOLDER/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/$FOLDER/config/client.toml
```

#### Create a systemd file for agoric node
```
sudo tee /etc/systemd/system/agd.service > /dev/null <<EOF
[Unit]
Description=Agoric Cosmos daemon
After=network-online.target

[Service]
# OPTIONAL: turn on JS debugging information.
#SLOGFILE=.agoric/data/chain.slog
User=$USER
# OPTIONAL: turn on Cosmos nondeterminism debugging information
#ExecStart=$(which agd) start start --log_level=info --trace-store=.agoric/data/kvstore.trace
ExecStart=$(which agd) start start --log_level=warn
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target

EOF
```

#### Download the latest snapshot
```
curl -L https://snapshots.kjnodes.com/agoric/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER
mv $HOME/$FOLDER/priv_validator_state.json.backup $HOME/$FOLDER/data/priv_validator_state.json
```
                                                        
## 6. Start synchronization
```
sudo systemctl daemon-reload
sudo systemctl start agd
sudo systemctl enable agd
sudo journalctl -u agd -f -n 100
```
Wait until your node is fully synchronized. To check your synchronization status use command bellow.
```
agd status 2>&1 | jq .SyncInfo
```
- If node show `false` - that means that you are synched and can contine. 
- If node show `true` - that means that you are **NOT** synched and should wait.

## 7. Create your wallet.
The comment bellow will give you a wallet address and mnemonic phrase, which you should save on safe place.
```
agd keys add wallet
```

## 8. Сreate own validator
```
agd tx staking create-validator \
--amount 1000000ubld \
--pubkey $(agd tendermint show-validator) \
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
--gas-prices 0.025ubld \
-y

```
Finaly you should see your validator in [Block Explorer](https://agoric.explorers.guru/) on Active or Inactive set.

## 9. Deleting a node
```
sudo systemctl stop agd
sudo rm -rf $FOLDER
sudo rm -rf agoric-sdk
sudo rm -rf /go/bin/agd
sudo rm -rf /etc/systemd/system/agd.service
```

## 10. Upgrade your node
```
cd agoric-sdk
git fetch --all
latestTag=$(curl -s https://api.github.com/repos/Agoric/agoric-sdk/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
yarn install
yarn build
(cd packages/cosmic-swingset && make)
agd version
```

#
👉[Webtropia](https://bit.ly/45KaUj4) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/agoric-585576150827532298)

👉[WebSite](https://agoric.com/)

👉[Official guide](https://github.com/Agoric/agoric-sdk)

👉[KJ Nodes Guide](https://services.kjnodes.com/mainnet/agoric/installation/)

👉[KJ Nodes Snapshot](https://services.kjnodes.com/mainnet/agoric/snapshot/)

👉[Agoric Explorer](https://agoric.explorers.guru/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
