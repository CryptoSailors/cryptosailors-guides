<p align="center">
 <img src="https://i.postimg.cc/L8DRwBr1/Ethereum-1.jpg"width="900"/></a>
</p>

# In this guide we will setup ETH RPC node on Goerli network

#### Flollowing parametrs:

4-CPU/8-GBRAM/400-GBSSD (On 7-OCT-2022 node occupie 250GB)

## 1. Node Preparation
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
```
sudo apt -y install software-properties-common wget curl ccze
```
## 2. Installing Geth
```
sudo add-apt-repository -y ppa:ethereum/ethereum
```
```
sudo apt -y install geth
```
## 3. Creating the JWT token
```
sudo mkdir -p /var/lib/ethereum
```
```
openssl rand -hex 32 | tr -d "\n" | sudo tee /var/lib/ethereum/jwttoken
```
```
sudo chmod +r /var/lib/ethereum/jwttoken
```
## 4. Configuring and launch Geth node
```
sudo useradd --no-create-home --shell /bin/false goeth
```
```
sudo mkdir -p /var/lib/goethereum
```
```
sudo chown -R goeth:goeth /var/lib/goethereum
```
Let's create a systemd file for our geth node.
```
tee /etc/systemd/system/geth.service > /dev/null <<EOF
[Unit]
Description=Go Ethereum Client - Geth (Goerli)
After=network.target
Wants=network.target

[Service]
User=goeth
Group=goeth
Type=simple
Restart=always
RestartSec=5
TimeoutStopSec=180
ExecStart=geth \
    --goerli \
    --http \
    --datadir /var/lib/goethereum \
    --metrics \
    --metrics.expensive \
    --pprof \
    --authrpc.jwtsecret=/var/lib/ethereum/jwttoken \
    --http.api=eth,net,web3,engine \
    --http.vhosts * \
    --http.addr 0.0.0.0

[Install]
WantedBy=default.target
```
Start your Goerli node
```
sudo systemctl daemon-reload
```
```
sudo systemctl start geth.service 
```
```
sudo systemctl status geth.service 
```
```
sudo systemctl enable geth.service
```
For checking logs
```
journalctl -u geth -f -n 100
```
For exit from logs press `CTRL+C`. Your node will not start synchronization and will looking for new peers. From this stage we should start configure a beacon node, which allow us start synchronization goerli ETH node.

## 5. Installing Lighthouse beacon.
Check the latest binary [release](https://github.com/sigp/lighthouse/releases) of Lighthouse node. At the time of writing this manual, the latest release is `v3.1.2`
```
cd ~
```
```
wget https://github.com/sigp/lighthouse/releases/download/v3.1.2/lighthouse-v3.1.2-x86_64-unknown-linux-gnu.tar.gz
```
```
tar -xvzf lighthouse-v3.1.2-x86_64-unknown-linux-gnu.tar.gz
```
```
rm -rf lighthouse-v3.1.2-x86_64-unknown-linux-gnu.tar.gz
```
```
sudo mv ~/lighthouse /usr/local/bin
```
## 6. Configuring your Lighthouse beacon node
```
sudo useradd --no-create-home --shell /bin/false lighthousebeacon
```
```
sudo mkdir -p /var/lib/lighthouse
```
```
sudo chown -R lighthousebeacon:lighthousebeacon /var/lib/lighthouse
```
Let's create a systemd file for our lighthousebeacone node.
```
tee /etc/systemd/system/lighthousebeacon.service > /dev/null <<EOF
[Unit]
Description=Lighthouse Ethereum Client Beacon Node (Prater)
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=lighthousebeacon
Group=lighthousebeacon
Restart=always
RestartSec=5
ExecStart=/usr/local/bin/lighthouse bn \
    --network prater \
    --datadir /var/lib/lighthouse \
    --http \
    --execution-endpoint http://127.0.0.1:8551 \
    --metrics \
    --validator-monitor-auto \
    --checkpoint-sync-url https://goerli.checkpoint-sync.ethdevops.io \
    --execution-jwt /var/lib/ethereum/jwttoken

[Install]
WantedBy=multi-user.target
```
Start your lighthousebeacon node
```
sudo systemctl daemon-reload
```
```
sudo systemctl start lighthousebeacon.service
```
```
sudo systemctl status lighthousebeacon.service
```
```
sudo systemctl enable lighthousebeacon.service
```
For checking logs
```
journalctl -u lighthousebeacon -f -n 100
```
For exit from logs press `CTRL+C`. Now your node should start synchronization proccess. 

#### Check synchronization status

By command bellow you can check the synchronization status of your goerli node
```
curl -X POST http://localhost:8545 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'
```
If output show `{"jsonrpc":"2.0","id":1,"result":false}` that means that your node goerli synchronized.

#

👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor


