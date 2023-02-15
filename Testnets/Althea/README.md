<p align="center">
 <img src="https://i.postimg.cc/FRptCXh4/68747470733a2f2f7062732e7477696d672e636f6d2f6578745f74775f766964656f5f7468756d622f313632333035313030.jpg"/></a>
</p>

# Althea testnet node guide installation.

## 1. Requirements.
#### Official 
- 4 CPU
- 8 GB RAM
- 100 GB SSD
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
CHAIN_ID=althea_7357-1
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.profile
source $HOME/.profile
```
## 3. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 4. Install a node
Make sure that you are installing the [latest release](https://github.com/althea-net/althea-chain/tags). In this guide we use release `v0.3.2`
```
git clone https://github.com/althea-net/althea-chain
cd althea-chain
git checkout v0.3.2 
make install
```
```
cd ~
```
```
althea init <your_node_name_here> --chain-id=$CHAIN_ID
```
```
wget https://raw.githubusercontent.com/althea-net/althea-chain-docs/main/testnet-3-genesis-collected-v2.json
```
```
althea tendermint unsafe-reset-all
```
```
mv testnet-3-genesis-collected-v2.json ~/.althea/config/genesis.json
```

## 5. Node Configuration
```
PEERS=d320b861277a338daefec6e620daafe07fc5ee19@65.108.199.36:20036,2dee418b26b6b12933f5b0a8431c73f1478ca325@65.108.43.113:36656,698edcaf59b14f7bf50b681ef1ee3046fa062c77@65.109.92.235:11056,7eb055628aee375914d7d265ef4bc01ea692fe95@65.109.82.106:31656,a81cf8f7f330e2e09bec93c866214f7b3b336849@65.109.87.88:26356,13e103fdcb66ff4238ef5a228f5fadea5fee2ebd@65.109.85.52:26656,4f3add677b0e4c8dec8b81101ea82620a19d5d0a@65.21.199.148:26633,c6e1ed7117cd56036cc51835945d155e9c474c01@167.235.144.3:26656,0aac1fc75b4a613f6bb7d15c6250350d478227a6@66.45.231.30:11144,8203297aacaea1d889fcf36240484c9efc217bbd@116.202.156.106:26656,856ac01afa0163c27b69e1b25464427310120924@85.25.134.23:26656,c831cd6ac278ab971eca94dda0c29191e8f39036@195.201.22.133:26656,d26fddea7ceb8cb5a52223702a23757cb09fad37@207.180.199.115:31656,733e9d5f995c2866df9f2e1254551940f060a70c@51.159.159.112:26656,53a4fe2e8eb17b307dfed6a88cbe5573617e34b5@89.71.164.61:28656,1ad56beb27ba5b5698d828dbd9823a220c978dcf@103.195.103.59:26656,aa500219761eecd7f1f02a8bfd21c6dcdbd3cf42@142.132.232.40:26656,24ae39234e1ceddc1585af9be8a6484edac79123@49.12.123.97:26656,617433cdf5411fc9241d0f77239f751a14669368@146.190.156.221:26656,cd71580f8ab4af6beeaf867702a86ca6f9331f71@65.19.136.133:23296,bdf94092f6dc380f6526f7b8b46b63192e95a033@173.212.222.167:29656,1f1d115b9a70aa72f321bae376b1c6e44bab4668@18.237.87.241:26656,96320aaab7794933fddbc2bb101e54b8697c58e7@141.95.65.26:26656,a3ac64c5c84817f3694a866298399e6ad71ff26c@65.21.53.39:26656,15e7baf69c0db5c25e26cd1f13eb0d52a7a708b5@142.202.241.235:26656,a51b45869b5403dc71251a69879c1eb1c3042bed@65.108.134.215:29336,3dc47addc0d8edfbfc0b388ab55e9e8c8c5d5f11@65.109.61.116:29656,937dcf8c45b7c64e5188a7036427f2ce86383035@95.165.89.222:24126,abc941c8539306d92b822ca787424ddd28eceb33@207.180.243.64:26656,1d9a103d1e24c590bdfb577537eddd19a322f886@65.109.92.240:17886,a069a13d8694e2bf0e0ee8e5435f5d2953979451@168.119.124.130:34656,c215cf295b05c1338fdf5070a7b2abde873f5a88@95.217.40.230:26656,11e8f38e3c5601e4ab2333d5a5bbb108a39b8e1c@159.69.110.238:26656,83147260a704b75283ca6da218516ee0eaa82956@170.64.156.36:26656,ab3ba67d06d109e135f5cd22a3d4d6b1784e3a70@161.97.65.170:36656,ba247bdf826a9636a8276d6a00d8004755f6bb18@162.19.238.210:26656,dc67cbe058b802aa34f64715b44474c462b4317b@65.108.237.224:36656,3aeffaa1ac7b6741110987cfae4604751ac7d865@107.22.132.229:26656,786bb2b153f94135713de303504debda11f3079a@65.108.134.122:26656,87b67a8758306c61f8bb7504a0881cc837373633@140.82.38.208:26656,cc542d9fb5f93780fc4004aa67f2b502686a24e8@144.76.27.79:61056,4f8729168c5454d04ff4a4d7b51986b2e97c68ff@165.232.104.13:26656,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@176.9.82.221:12456
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.althea/config/config.toml
sed -i 's|indexer =.*|indexer = "'null'"|g' $HOME/.althea/config/config.toml
```
#### Optional (You can skip this step)
If you run more than one cosmos node, you can change a ports using the comands bellow.
```
COSMOS_PORT=11
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.profile
source $HOME/.profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/.althea/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/.althea/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/.althea/config/client.toml
```

#### Create a systemd file for lava node
if you run from root, insert `USER=root` in systemd configuration.
```
sudo tee /etc/systemd/system/althead.service > /dev/null <<EOF
[Unit]
Description=Althea Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which althea) start
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
sudo systemctl start althead
sudo systemctl enable althead
sudo journalctl -u althead -f -n 100
```
Wait until your node is fully synchronized. To check your synchronization status use command bellow.
```
althea status 2>&1 | jq .SyncInfo
```
- If node show `false` - that means that you are synched and can contine. 
- If node show `true` - that means that you are **NOT** synched and should wait.

## 7. Create your wallet and claim test tokens.
The comment bellow will give you a wallet address and mnemonic phrase, which you should save on safe place.
```
althea keys add wallet
```
## 8. Сreate own validator
```
althea tx staking create-validator \
--amount="1000000ualthea" \
--pubkey=$(althea tendermint show-validator) \
--moniker="Yor_validator_name" \
--chain-id="$CHAIN_ID" \
--from="myvalidatorkey" \
--commission-rate="0.1" \
--commission-max-rate=0.15 \
--commission-max-change-rate=0.1 \
--min-self-delegation=1 \
--gas=auto \
-y
```
Finaly you should see your validator in [Block Explorer](https://test.anode.team/althea) on Active or Inactive set.

## 9. Deleting a node
```
sudo systemctl stop althead
sudo rm -rf .althea
sudo rm -rf althea-chain
sudo rm -rf /go/bin/althea
sudo rm -rf /etc/systemd/system/althead.service
```
#
👉[Webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/ps6B3yaMb7)

👉[WebSite](https://www.althea.net/)

👉[Official guide](https://github.com/althea-net/althea-chain-docs/blob/main/docs/testnet-3-launch.md)

👉[Althea Explorer](https://test.anode.team/althea)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
