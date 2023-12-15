<p align="center">
 <img src="https://i.postimg.cc/SKpCDTMS/Immutable-1.png"width="900"/></a>
</p>

# In this guide we will setup ImmutableX Mainnet RPC node.

#### Flollowing parametrs:
- 2 CPU 
- 4 GB RAM
- 100 GB SSD

#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 1. Node Preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
```
sudo apt-get install openssl
```

## 2. Install docker 
```
sudo apt install docker.io -y
```

## 3. Install and Start ImmytableX mainnet node

```
sudo mkdir opt && cd opt && sudo mkdir immutable-zkevm
cd ~
sudo chmod -R 777 opt
```
```
sudo docker pull ghcr.io/immutable/go-ethereum/go-ethereum:v0.0.8
```
```
sudo docker tag ghcr.io/immutable/go-ethereum/go-ethereum:v0.0.8 geth
```
```
sudo docker run \
  --rm \
  -v $HOME/opt/immutable-zkevm:/mnt/geth \
  --name geth \
  geth init \
  --datadir /mnt/geth /etc/geth/mainnet.json 
```
```
sudo docker run \
  -d \
  --restart=always \
  -v $HOME/opt/immutable-zkevm:/mnt/geth \
  --name geth \
  -p 8936:8545 \
  geth \
  --config /etc/geth/mainnet.toml \
  --datadir /mnt/geth \
  --keystore /mnt/geth/keystore \
  --networkid 13371 \
  --http \
  --http.port "8545" \
  --http.addr "0.0.0.0"
```
Check you logs
```
sudo docker logs geth -f --tail 100
```
## 4. Check your synch
Once your node is fully synced, the output from above will say `false`. To test your Immutable RPC node, you can send an RPC request using cURL
```
curl -X POST http://localhost:8936 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'
```

## 5. Link to your RPC
- `http://YOUR_IP:8936`

## 6. Delete your ImmutableX node
```
sudo docker stop geth
sudo docker kill geth
sudo docker rm geth
sudo rm -rf opt
```
#

👉[Webtropia — server rental](https://bit.ly/45KaUj4)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

🔰[Our WebSite](cryptosailors.tech)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
