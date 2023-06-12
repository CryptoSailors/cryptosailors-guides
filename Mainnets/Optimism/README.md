<p align="center">
 <img src="https://i.postimg.cc/JncQhdYZ/image-2022-04-27-191225357.png"width="900"/></a>
</p>

# In this guide we will setup Optimism mainnet RPC node.

#### Flollowing parametrs:
- 8 CPU 
- 16 GB RAM
- 500+ GB SSD

#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) with extended disk.
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 1. Node Preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
## 2. Install golang go.
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 3. Install a node.
```
mkdir optimism-node && cd optimism-node && mkdir node
openssl rand -hex 32 > node/engine_jwt_secret.txt
openssl rand -hex 32 > node/p2pkey.txt
sudo chmod +x node/engine_jwt_secret.txt
sudo chmod +x node/p2pkey.txt
git clone https://github.com/ethereum-optimism/op-geth
cd op-geth
latestTag=$(curl -s https://api.github.com/repos/ethereum-optimism/op-geth/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
go build -o ~/go/bin/op-geth ./cmd/geth
cd ~/optimism-node
git clone https://github.com/ethereum-optimism/optimism
cd optimism
latestTag=$(curl -s https://api.github.com/repos/ethereum-optimism/optimism/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
go build -o ~/go/bin/op-node ./op-node/cmd
cd 
```
## 4. Download Snapshot.
For this step i recomend to use `screen` or `tmux` module. The Snapshot will take about 450GB.
```
mkdir temp
cd temp
aria2c https://storage.googleapis.com/oplabs-mainnet-data/mainnet-bedrock.tar
```
```
tar -xvf mainnet-bedrock.tar
cd
```
## 5. Create services.
#### op-geth
```
sudo tee <<EOF >/dev/null /etc/systemd/system/op-geth.service
[Unit]
Description=op-geth optimism
After=network-online.target

[Service]
User=$USER
ExecStart=/home/optimism/go/bin/op-geth \
  --ws \
  --ws.port=8746 \
  --ws.addr=0.0.0.0 \
  --ws.origins="*" \
  --ws.api=debug,eth,txpool,net,engine,web3 \
  --http \
  --http.port=8745 \
  --http.addr=0.0.0.0 \
  --http.vhosts="*" \
  --http.corsdomain="*" \
  --http.api=eth,net,debug \
  --authrpc.addr=localhost \
  --authrpc.jwtsecret=/home/optimism/optimism-node/node/engine_jwt_secret.txt \
  --authrpc.port=8751 \
  --authrpc.vhosts="*" \
  --datadir=/home/optimism/optimism-node/node/gethdata \
  --verbosity=3 \
  --rollup.disabletxpoolgossip=true \
  --rollup.sequencerhttp=https://mainnet-sequencer.optimism.io \
  --nodiscover \
  --syncmode=full \
  --maxpeers=0 \
  --verbosity=4 \
  --metrics \
  --metrics.addr=0.0.0.0 \
  --metrics.port=6770 \
  --networkid=10 \
  --pprof \
  --pprof.addr=0.0.0.0 \
  --pprof.port=6760 \
  --port "30307" \
  --snapshot=false
Restart=always
RestartSec=3
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
```
#### op-node
```
sudo tee <<EOF >/dev/null /etc/systemd/system/op-node.service
[Unit]
Description=op-node optimism
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/go/bin/op-node \
  --l1=http://YOUR_ETHEREUM_RPC_URL \
  --l1.trustrpc \ 
  --l2=http://127.0.0.1:8751 \
  --network=mainnet \
  --verifier.l1-confs=2 \
  --l1.epoch-poll-interval=2m \
  --rpc.enable-admin \
  --rpc.addr=0.0.0.0 \
  --rpc.port=8845 \
  --metrics.enabled \
  --metrics.addr=0.0.0.0 \
  --metrics.port=6870 \
  --l2.jwt-secret=$HOME/optimism-node/node/engine_jwt_secret.txt \
  --pprof.enabled \
  --pprof.addr=0.0.0.0 \
  --pprof.port=6860 \
  --p2p.priv.path=$HOME/optimism-node/node/p2p_priv.txt \
  --p2p.peerstore.path=$HOME/optimism-node/node/opnode_peerstore_db \
  --p2p.discovery.path=$HOME/optimism-node/node/opnode_discovery_db \
  --p2p.listen.ip=0.0.0.0 \
  --p2p.listen.tcp=2020 \
  --p2p.listen.udp=2020 \
  --p2p.peers.lo=10 \
  --p2p.peers.hi=20 \
  --p2p.nat \
  --log.level=info \
  --log.format=logfmt
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
##### Note. If you have L1 node erigon, parameter --l1.rpckind=erigon is mandatory, otherwise you can do without it.

## 6. Start all services.
```
sudo systemctl daemon-reload
sudo systemctl enable op-geth
sudo systemctl enable op-node.service
sudo systemctl start op-geth
sudo systemctl start op-node
```
## 7. Stop all services and install snapshot
```
sudo systemctl stop op-geth
sudo systemctl stop op-node
```
```
sudo rm -rf $HOME/optimism-node/node/gethdata/geth
sudo mv temp/geth $HOME/optimism-node/node/gethdata/geth
```
```
sudo systemctl start op-geth
sudo systemctl start op-node
```
## 8. Check logs.
```
sudo journalctl -u op-geth.service -f -n 100
sudo journalctl -u op-node.service -f -n 100
```

## 9 Your RPC url are:

- `http://YOUR_IP:8745`
- `ws://YOUR_IP:8746`
#

👉[Webtropia — server rental](https://www.webtropia.com/?kwk=255074042020228216158042)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Optimism Official docs](https://github.com/smartcontracts/simple-optimism-node)

👉[Optimism op-geth Github](https://github.com/ethereum-optimism/op-geth)

👉[Optimism op-node Github](https://github.com/ethereum-optimism/optimism/releases)

👉[Optimism Bedrock Snapshot](https://storage.googleapis.com/oplabs-mainnet-data/mainnet-bedrock.tar) 

👉[Optimism Mainnet Explorer](https://optimistic.etherscan.io/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
