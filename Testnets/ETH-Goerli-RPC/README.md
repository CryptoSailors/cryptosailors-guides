<p align="center">
 <img src="https://i.postimg.cc/L8DRwBr1/Ethereum-1.jpg"width="900"/></a>
</p>

# In this guide we will setup ETH RPC node on Goerli network

#### Flollowing parametrs:

- 4-CPU
- 8-GBRAM
- 400-GBSSD

  #### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4) with extended SSD or NVME disk.
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 1. Node Preparation
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
```
sudo apt install software-properties-common -y
```
```
sudo apt-get install protobuf-compiler -y
```
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
```
```
source $HOME/.cargo/env
```

## 2. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 3. Installing Geth
```
git clone https://github.com/ethereum/go-ethereum
cd go-ethereum
latestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
git checkout $latestTag
make 
sudo mv build/bin/geth /usr/bin/
geth version
cd ~
```

## 4. Install Lighthouse
```
git clone https://github.com/sigp/lighthouse.git
cd lighthouse
git checkout stable
make
```
```
openssl rand -hex 32 > jwt.hex
sudo chmod +x jwt.hex
```
Close redactor buy CTRL+X,Y,Enter.
```
cd ~
```

## 5. Configuring and launch Geth and Lighthouse node.
```
sudo tee /etc/systemd/system/geth.service > /dev/null <<EOF
[Unit]
Description=Ethereum Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which geth) \
--goerli \
--rpc.gascap 150000000 \
--state.scheme=path \
--syncmode "snap" \
--http \
--http.api=eth,net,web3,engine \
--http.vhosts * \
--http.addr 0.0.0.0 \
--authrpc.jwtsecret=$HOME/lighthouse/jwt.hex

Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target

EOF
```
Launch our Geth node
```
sudo systemctl daemon-reload
sudo systemctl enable geth
sudo systemctl start geth
sudo journalctl -u geth -f -n 100
```
Our node start looking for peers and beacon. Now we need configure our lighthouse beacon. We will launch a lighthouse node from [snapshot](https://eth-clients.github.io/checkpoint-sync-endpoints/).
```
sudo tee /etc/systemd/system/lighthouse.service > /dev/null <<EOF
[Unit]
Description=lighthouse
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/.cargo/bin/lighthouse bn \
 --network goerli \
 --http \
 --http-address 0.0.0.0 \
 --execution-endpoint http://localhost:8551 \
 --execution-jwt /home/ethereum/lighthouse/jwt.hex \
 --disable-deposit-contract-sync \
 --checkpoint-sync-url=https://prater-checkpoint-sync.stakely.io

Restart=always
RestartSec=3
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
EOF
```
Launch our lighthouse node
```
sudo systemctl daemon-reload
sudo systemctl enable lighthouse
sudo systemctl start lighthouse
sudo journalctl -u lighthouse -f -n 100
```
By command bellow you can check a status of synchronization process of your node.
```
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'
```
- If the show `false` that means that your node is fully synchronized.

## 6. Your Ethereum RPC endpoint
- `http://YOUR_IP:8545`

## 7. Update your Ethereum Goerli node
You can download autoscript and launch it when new update is relesead or update a node manualy.

#### Ethereum Goerli auto update.
```
wget https://github.com/CryptoSailors/cryptosailors-guides/raw/main/Testnets/ETH-Goerli-RPC/ethereum_update.sh
sudo chmod +x ethereum_update.sh
```
Launch script
```
./ethereum_update.sh
```

#### Ethereum Goerli manual update
```
source .bash_profile
cd go-ethereum
git pull
latestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
git checkout $latestTag
make
```
```
sudo mv build/bin/geth /usr/bin/
geth version 
sudo systemctl restart geth 
sudo journalctl -u geth -f -n 100
```

## 8. Update your Lighthouse Beacone node
You can download autoscript and launch it when new update is relesead or update a node manualy.

#### Lighthouse Beacone auto update.
```
wget https://raw.githubusercontent.com/CryptoSailors/cryptosailors-guides/main/Testnets/ETH-Goerli-RPC/lighthouse_update.sh
sudo chmod +x lighthouse_update.sh
```
Launch script
```
./lighthouse_update.sh
```

#### Lighthouse Beacone manual update
```
source .bash_profile
cd lighthouse
git pull
latestTag=$(curl -s https://api.github.com/repos/sigp/lighthouse/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make
```
```
cd ~
./.cargo/bin/lighthouse --version
sudo systemctl restart lighthouse
sudo journalctl -u lighthouse -f -n 100
```
#

👉[Webtropia — server rental](https://bit.ly/45KaUj4)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Lighthouse](https://github.com/sigp/lighthouse)

👉[Ethereum Github](https://github.com/ethereum/go-ethereum)

👉[Ethereum Goerli Explorer](https://goerli.etherscan.io/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor


