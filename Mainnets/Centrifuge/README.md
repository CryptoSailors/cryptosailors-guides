<p align="center">
 <img src=""/></a>
</p>

# In this guide we will install a Centrifuge Mainnet RPC node.

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
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
```

## 3. Install a Centrifuge node
```
git clone https://github.com/centrifuge/centrifuge-chain
cd centrifuge-chain
latestTag=$(curl -s https://api.github.com/repos/centrifuge/centrifuge-chain/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
cargo build --release
sudo chmod +x target/release/centrifuge-chain
sudo mkdir data
```

## 4. Crate a systemd file


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
