<p align="center">
 <img src="https://i.postimg.cc/FsTXy88y/linea-cover.png"width="900"/></a>
</p>

# In this guide we will setup Linea mainnet RPC node.

#### Flollowing parametrs:
- 4CPU
- 16GB RAM
- 100 GB SSD

#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) with extended SSD or NVME disk.
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 1. Node Preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```

## 2. Install golang Go.

Install Golang go according step 2 of [this instruction](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22).

## 3. Install Geth
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
## 4. Install and configure Linea mainnet node
```
mkdir -p $HOME/.linea/config
cd $HOME/.linea/config
wget -O genesis.json https://docs.linea.build/files/genesis.json
cd $HOME
mkdir -p $HOME/.linea/data
geth --datadir $HOME/.linea/data init $HOME/.linea/config/genesis.json
```
```
NETWORK_ID="59144"
BOOTNODES="enode://ca2f06aa93728e2883ff02b0c2076329e475fe667a48035b4f77711ea41a73cf6cb2ff232804c49538ad77794185d83295b57ddd2be79eefc50a9dd5c48bbb2e@3.128.49.168:30303"
echo "export NETWORK_ID=${NETWORK_ID}" >> $HOME/.bash_profile
echo "export BOOTNODES=${BOOTNODES}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
Configure systemd file
```
sudo tee /etc/systemd/system/linea.service > /dev/null <<EOF
[Unit]
Description=Linea node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which is geth) \
--datadir /home/linea/.linea/data \
--networkid 59144 \
--miner.gasprice 1000000000 \
--miner.gaslimit '0x3A2C940' \
--rpc.allow-unprotected-txs \
--txpool.accountqueue 50000 \
--txpool.globalqueue 50000 \
--txpool.globalslots 50000 \
--txpool.pricelimit 1000000000 \
--rpc.txfeecap 100 \
--gpo.maxprice 100000000000000 \
--txpool.nolocals \
--port 30309 \
--http \
--http.addr "0.0.0.0" \
--http.port 8657 \
--authrpc.port 8656 \
--http.corsdomain '*' \
--http.api 'web3,eth,txpool,net' \
--http.vhosts='*' \
--ws \
--ws.addr "0.0.0.0" \
--ws.port 8657 \
--ws.origins '*' \
--ws.api 'eth,net,web3,txpool' \
--bootnodes enode://ca2f06aa93728e2883ff02b0c2076329e475fe667a48035b4f77711ea41a73cf6cb2ff232804c49538ad77794185d83295b57ddd2be79eefc50a9dd5c48bbb2e@3.128.49.168:30303 \
--syncmode full \
--metrics \
--pprof \
--pprof.addr "0.0.0.0" \
--pprof.port 9545 \
--verbosity 3

Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]

WantedBy=multi-user.target

Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]

WantedBy=multi-user.target
EOF
```
## 5. Start a Linea mainnet node.
```
sudo systemctl enable linea
sudo systemctl start linea
sudo journalctl -u linea -f -n 100 -o cat
```
## 6. Link on your rpc:

- `http://YOUR_IP:8657`

#

👉[Webtropia — server rental](https://www.webtropia.com/?kwk=255074042020228216158042)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Linea Official docs](https://docs.linea.build/build-on-linea/run-a-node)

👉[Linea Explorer](https://lineascan.build/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

**Guide created by**

Pavel-LV | C.Sailors#7698 / @SeaInvestor
