<p align="center">
 <img src="https://i.postimg.cc/FsTXy88y/linea-cover.png"width="900"/></a>
</p>

# In this guide we will setup Linea testnet RPC node.

#### Flollowing parametrs:
- 4CPU
- 16GB RAM
- 400 GB SSD

#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4) with extended SSD or NVME disk.
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
wget -O genesis.json https://docs.linea.build/files/l2-genesis-uat.json
cd $HOME
mkdir -p $HOME/.linea/data
geth --datadir $HOME/.linea/data init $HOME/.linea/config/genesis.json
```
```
NETWORK_ID="59140"
BOOTNODES="enode://db471f0bad1da4f5e48042d0411bc38d5a245cf30ff76191e454c9ff2e27e57d45009b9c6e50d582c44332b05f2d747a8e995aa20399e80c22b1abb069332dde@3.17.183.45:30303,enode://1b10ff18e0d5055111af8cffe083d8d123ebede1dd5d81b3f8ce069ead6f0e70ec3217a0fa163bebaf1cd87b78e8f630182d703e1aebde93996dd5f67fa89389@18.117.161.184:30303,enode://25a42af9d7573a6299b54bb3c2d6566e59079ab1b94b4d42aa44325252d85f45f0bfe8b40dd476a4ee30c7007b61ab34375875ffa668b73eccc9c32640b17e48@3.20.238.193:30303,enode://3dfed9020ade850dca85d2855d42bfb431d1dbfdaec529ad66773bff434e473c071849dddf9cd43f9c529777a384bf5293463baecd4aea7623e575877fd30024@3.18.97.19:30303,enode://68848179e1bfe737045d19734db8f83ce3f85739d551a1e4c4661486380f69677316445375323172e5fcdbd5e26ccbb94306b647b7ac0468de9e9e775a0fbed6@18.190.156.63:30303"
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
--networkid $NETWORK_ID \
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
--bootnodes $BOOTNODES \
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

## 7. Delete your node
```
sudo systemctl stop linea
sudo rm -rf /etc/systemd/system/linea.service
sudo rm -rf .linea
sudo rm -rf go-ethereum
```

#

👉[Webtropia — server rental](https://bit.ly/45KaUj4)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Linea Official docs](https://docs.linea.build/build-on-linea/run-a-node)

👉[Linea Explorer](https://goerli.lineascan.build/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

**Guide created by**

Pavel-LV | C.Sailors#7698 / @SeaInvestor
