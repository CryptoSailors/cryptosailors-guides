<p align="center">
 <img src="https://i.postggimg.cc/4dRpshzT/Agoricjpg.jpg"/></a>
</p>

# StoryProtocol testnet node guide installation.

## 1. Requirements.

#### Official 
- 4 CPU or more
- 8 GB RAM
- 200 GB SSD
  
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
## 3. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 4. Install a node
```
mkdir .story && cd .story && mkdir story && mkdir geth
cd ~
cd go && mkdir bin
cd ~
```
Check the latest version of execution client [geth-story](https://github.com/piplabs/story-geth/releases). Latest v0.9.2
```
wget https://story-geth-binaries.s3.us-west-1.amazonaws.com/geth-public/geth-linux-amd64-0.9.2-ea9f0d2.tar.gz
tar -xvzf geth-linux-amd64-0.9.2-ea9f0d2.tar.gz
mv geth-linux-amd64-0.9.2-ea9f0d2/geth $HOME/go/bin/
```
Check the latest version of consensus client [story](https://github.com/piplabs/story/releases/tag/v0.9.11). Latest v0.9.11
```
wget https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/story-linux-amd64-0.9.11-2a25df1.tar.gz
tar -xvzf story-linux-amd64-0.9.11-2a25df1.tar.gz
mv story-linux-amd64-0.9.11-2a25df1/story $HOME/go/bin
```

## 5. Node Configuration
```
story init --moniker moniker --network iliad
```
Add Peers to your node
```
sodo nano .story/story/config/config.toml
```
Find line `presistent_peers` and insert line bellow.
```
presistent_peers = "6bb4ed28b08a186fc1373cfc2e96b83165c1e882@162.55.245.254:33656,ac7f6fd3b535099d65aad9b23315e69d4ed5e32f@139.59.139.135:26656,fc226b4830bf7947fe7193e83e20501722e7406d@111.119.221.114:26656,f1ec81f4963e78d06cf54f103cb6ca75e19ea831@217.76.159.104:26656,8876a2351818d73c73d97dcf53333e6b7a58c114@3.225.157.207:26656,eeb7d2096a887f8ff8fdde2695c394fcf5a19273@194.238.30.192:36656,c1b1fb63cb1217e6c342c0fd7edf28902e33f189@100.42.179.9:26656"
```
#### Create a systemd file for gethstory node
```
sudo tee /etc/systemd/system/gethstory.service > /dev/null <<EOF
[Unit]
Description=Geth Story
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/go/bin/geth --iliad --syncmode full
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]

WantedBy=multi-user.target

EOF
```
#### Create a systemd file for story node
```
sudo tee /etc/systemd/system/story.service > /dev/null <<EOF
[Unit]
Description=Story
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/go/bin/story run
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]

WantedBy=multi-user.target

EOF
```
                                                        
## 6. Start synchronization
```
sudo systemctl daemon-reload
sudo systemctl enable gethstory
sudo systemctl enable story
sudo systemctl start gethstory
sudo systemctl start story
sudo journalctl -u gethstory -f -n 100 -o cat
sudo journalctl -u story -f -n 100 -o cat

```
Wait until your node is fully synchronized. To check your synchronization status use command bellow:
#### For execution node:
```
geth attach $HOME/.story/geth/iliad/geth.ipc
```
- `eth.blockNumber` will print out the latest block geth is sync’d to - if this is undefined there is likely a peer connection or syncing issue
- `admin.peers` will print out a list of other geth nodes your client is connected to - if this is blank there is a peer connectivity issue
- `eth.syncing` will return `false` if geth is in the process of syncing, `true` otherwise
- `exit` to exit from geth
```
story status 2>&1 | jq .SyncInfo
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
