<p align="center">
 <img src="https://i.postimg.cc/9fbwJCZQ/Humans.jpg"/></a>
</p>

# Humans mainnet node guide installation.

## 1. Requirements.
#### Official 
- 6 CPU or more
- 32 GB RAM
- 500 GB SSD
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
CHAIN_ID=humans_1089-1
export FOLDER=.humansd
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## 3. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 4. Install a node
```
git clone https://github.com/humansdotai/humans
cd humans
latestTag=$(curl -s https://api.github.com/repos/humansdotai/humans/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make install
humansd version
```
```
cd ~
```
```
humansd init moniker --chain-id=$CHAIN_ID
```
```
wget -O $HOME/$FOLDER/config/genesis.json "https://raw.githubusercontent.com/humansdotai/mainnets/main/mainnet/1/genesis.json"
```
## 5. Node Configuration
```
PEERS=
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$FOLDER/config/config.toml
sed -i 's|indexer =.*|indexer = "'null'"|g' $HOME/$FOLDER/config/config.toml
```
#### Optional (You can skip this step)
If you run more than one cosmos node, you can change a ports using the comands bellow.
```
COSMOS_PORT=12
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.profile
source $HOME/.bash_profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/$FOLDER/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/$FOLDER/config/client.toml
```

#### Create a systemd file for humans node
```
sudo tee /etc/systemd/system/humansd.service > /dev/null <<EOF
[Unit]
Description=Humans Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which humansd) start
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
sudo systemctl start humansd
sudo systemctl enable humansd
sudo journalctl -u humansd -f -n 100
```
Wait until your node is fully synchronized. To check your synchronization status use command bellow.
```
humansd status 2>&1 | jq .SyncInfo
```
- If node show `false` - that means that you are synched and can contine. 
- If node show `true` - that means that you are **NOT** synched and should wait.

## 7. Create your wallet and claim test tokens.
The comment bellow will give you a wallet address and mnemonic phrase, which you should save on safe place.
```
humansd keys add wallet
```
## 8. Сreate own validator
```
humansd tx staking create-validator \
  --amount=1000000000000000000aheart \
  --pubkey=$(humansd tendermint show-validator) \
  --moniker="choose a moniker" \
  --chain-id=$CHAIN_ID \
  --commission-rate="0.05" \
  --commission-max-rate="0.10" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1000000" \
  --gas="auto" \
  --gas-prices="1800000000aheart" \
  --from=wallet \
  -y
```
Finaly you should see your validator in [Block Explorer](https://humans.explorers.guru/) on Active or Inactive set.

## 9. Deleting a node
```
sudo systemctl stop humansd
sudo rm -rf $FOLDER
sudo rm -rf humans
sudo rm -rf /go/bin/humansd
sudo rm -rf /etc/systemd/system/humansd.service
```

## 10. Upgrade your node
```
cd humans
git pull
latestTag=$(curl -s https://api.github.com/repos/humansdotai/humans/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make install
humansd version
```

#
👉[Webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/humansdotai)

👉[WebSite](https://humans.ai/)

👉[Official guide](https://github.com/humansdotai/testnets)

👉[Humans Explorer](https://humans.explorers.guru/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
