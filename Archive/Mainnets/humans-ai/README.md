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
wget -O $HOME/$FOLDER/config/genesis.json "https://raw.githubusercontent.com/humansdotai/mainnets/main/mainnet/1/genesis_1089-1.json"
```
## 5. Node Configuration
```
PEERS=6d10dcac248d28e8c445841db51f34f9c26442c2@88.217.142.187:29001,81e49a66b928e3a8ba4ce61e959603b1ecd36d96@89.40.71.226:26656,c28ca17b1bad34a3ee5f0fde7568c73b49741479@65.108.108.54:8888,fbfcef080c6c631b03c6bb2832ae608931b1ce41@136.243.55.237:26656,dbf538cdb0f4d5ae4bd90fe2724b95d75b364ce7@138.3.43.147:26656,f7c4bde2eaeab04aff9872d50d5174472b087114@91.194.30.201:26656,37f2636e526869522131c74f098d507000c71aa0@167.235.115.119:26656,aaf071233f5481d50f20cff0bd0a55e6b3aef948@46.4.112.18:26656,dfccfc9156758de072e7287d442a2d3f00770a98@89.39.106.78:26656,91f91757091dab73f39f32f4502f94408fa79ec7@85.10.211.246:26656,2b882f794ed974031b5b435fbf1a755b668d7529@178.23.126.79:26656,f9344349e8435362bc7f21f67b9b61d2f1d6891b@152.32.174.173:26656,8204f0ddbb462749703a58ad6e4e57c5ea5a3379@193.34.212.99:26656,98274e2dcc6b5520c9818a6fdfcf6bde347f1d70@172.0.1.31:26656,a1ad90f3abf8e2875fb8c11f43498a7a8f63c9ad@139.59.6.61:26656,dc4c999d252b1cf99a341b3e6e752bd173c0fabf@51.89.195.66:28656,1d9face4d74f4d65142fa966b8cd4bb6cb4e8a37@148.113.9.36:26656,025cdc1186815f3f28567b30a1667130f0f6c863@212.47.234.245:26656,f0944423224746e56e51d8761893d20a1b335a79@172.104.108.55:26656,524d635a8b60111ba5e44ca9bea4948d84b5a937@65.109.154.185:30656,521ee99723e7edd9b9b14ada1ed382a14a82b69a@65.109.106.211:26656,f9a289d71b2325ee87e9a358540e64fe97c3cf36@148.113.143.77:26656,c138c2f5362be412ae93b59dd2f529df773fd1a1@116.202.85.52:26656,b05e9018dbe13d5706a6eba13050890865dbe1c2@135.181.208.166:28656,adb426cf95737cd79650749cddd8c881adeeabca@135.181.44.81:26656,32793227512886818e6c13a928ccfd675c0030c3@51.79.82.138:26656,88f612bd4f3f57e3b4b6d9b5ad2bebe69d57450b@77.246.159.0:26656,497886715ac23475f7428bd177b9fa53ff886a8d@167.235.2.246:43957,1f16fe691763a62f262c0d149fae57e22bd2fb47@65.108.126.21:26656,02778d5301e5054ec0ee213902a2ae6f16d03ac8@45.79.208.135:26656,44deaab1264724b6e98ee3882dc2fe19defe033c@135.181.156.110:26656,f913050241ce5fd49ea3783ed21724ad05db7291@65.109.125.235:26656,d48d615723693de93148dd3ef16bbb000a3022cb@44.232.147.30:26656,7fe9fed5e1e07692c332ea38ff4ef5ad2ee0248c@138.201.121.185:26690,20f95f8b8dd32b94b593dc3e8fcf0b0aeb74b85d@94.237.93.65:26656,aad2aadbe97cca1079d983f213ea90805e9fe765@162.55.145.72:46656,9193e655f0581b4acf2e87976ac0b55795359742@167.235.177.226:26656,78040907fb2391c958ffbb5fb170c0c48499da62@10.10.1.135:26656,7ea40560ffd03cfd1fde044427e3410a2aa7a839@65.21.132.27:26656,abd78601b249e56a0d88d8ea361bae8e36cbf804@103.180.28.92:26656,e538c77720999c6d21a2789aebfbffe6e5464d86@104.244.208.243:18456,7d8eea3d6d60c3e60e51b8f55db37e62dc0ec8b4@51.79.77.103:26656,4fc061477e0e08190137145ca8f6629a2564a347@65.108.244.5:12256,2628d82e90f0b58b823fdbc42a1a1629645e2293@51.89.98.102:55686,7889ee17b291451155190d40426e6154be4e1abc@135.181.142.60:15608,9a4c00c2d3bb30204561dbe7d6cb7d1a7ff9880b@65.108.213.235:26656,33f4d6b3a09e5ee651b49b2f6e0eb3294a3adb86@135.181.133.120:26656,250d5926777e735519813157e444f84212fc8290@5.161.216.102:26656,e29d6dab79b5801029bde71d90ffe5d35c7b7424@185.246.87.48:26656,7e0bdd0459f29183c9ec1e62f31f7b678d639452@69.197.23.33:26656
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
