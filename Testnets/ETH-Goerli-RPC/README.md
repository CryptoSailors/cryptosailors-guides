<p align="center">
 <img src="https://i.postimg.cc/L8DRwBr1/Ethereum-1.jpg"width="900"/></a>
</p>

# In this guide we will setup ETH RPC node on Goerli network

#### Flollowing parametrs:

- 4-CPU
- 8-GBRAM
- 400-GBSSD 

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
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
```
```
source $HOME/.cargo/env
```
## 2. Installing Geth
```
sudo add-apt-repository -y ppa:ethereum/ethereum
```
```
sudo apt -y install geth
```
## 3. Install Lighthouse
```
git clone https://github.com/sigp/lighthouse.git
cd lighthouse
git checkout stable
make
```
Open nano redactor and insert key from [generator](https://seanwasere.com/generate-random-hex/)
```
sudo nano jwt.hex
```
Close redactor buy CTRL+X,Y,Enter.
```
cd ~
```
## 4. Configuring and launch Geth and Lighthouse node.
```
sudo tee /etc/systemd/system/geth.service > /dev/null <<EOF
[Unit]
Description=Ethereum Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/bin/geth --goerli --syncmode "snap" --http --http.api=eth,net,web3,engine --http.vhosts * --http.addr 0.0.0.0  --authrpc.jwtsecret=/root/lighthouse/jwt.hex
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
ExecStart=/root/.cargo/bin/lighthouse bn --network goerli --execution-endpoint http://localhost:8551 --execution-jwt /root/lighthouse/jwt.hex --http  --disable-deposit-contract-sync --checkpoint-sync-url=https://prater-checkpoint-sync.stakely.io
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
#

👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Lighthouse](https://github.com/sigp/lighthouse)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor


