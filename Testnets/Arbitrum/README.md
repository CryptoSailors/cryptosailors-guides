<p align="center">
 <img src="https://i.postimg.cc/RZdG5Yvq/arbitrum-layer-2-nitro-upgrade-goes-live-ahead-of-ethereum-merge-900x478.jpg"width="900"/></a>
</p>

# In this guide we will setup Arbitrum testnet RPC node.

#### Flollowing parametrs:
- 2 CPU 
- 4 GB RAM
- 600 GB SSD

## 1. Node Preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```

## 2. Install docker and docker-compose
Check the latest version of [docker-compose](https://github.com/docker/compose/releases) and follow the guide.
```
sudo apt install docker.io -y
git clone https://github.com/docker/compose
cd compose
git checkout v2.16.0
make
cd ~
sudo mv compose/bin/build/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo docker-compose version
```
## 3. Install and Start Arbitrum testnet node
First check latest realiease. In our case the [latest release](https://github.com/OffchainLabs/nitro/tags) is `offchainlabs/nitro-node:v2.0.11-8e786ec`
```
RELEASE="offchainlabs/nitro-node:v2.0.11-8e786ec"
mkdir -p $HOME/data/arbitrum
chmod -fR 777 $HOME/data/arbitrum
```
```
sudo docker run --rm -it -d -v /path/to/data/arbitrum:/home/user/.arbitrum -p 0.0.0.0:8550:8547 -p 0.0.0.0:8549:8548 $RELEASE --l1.url <YOUR_GOERLI_ETH_RPC_URL> --l2.chain-id=421613 --http.api=net,web3,eth,debug --http.corsdomain=* --http.addr=0.0.0.0 --http.vhosts=*
```
To check your logs: 
```
sudo docker logs arbitrum -f --tail 100
```
## 5. Check your synch
Once your node is fully synced, the output from above will say `false`. To test your Arbitrum RPC node, you can send an RPC request using cURL
```
curl -X POST http://localhost:8550 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'
```

## 6. Link to your RPC
- `http://YOUR_IP:8550`

#

👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Arbitrum Official docs](https://docs.axelar.dev/validator/external-chains/arbitrum)

👉[Arbitrum Github](https://github.com/OffchainLabs/nitro)

👉[Arbitrum Goerli Explorer](https://goerli.arbiscan.io/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
