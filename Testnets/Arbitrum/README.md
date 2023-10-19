<p align="center">
 <img src="https://i.postimg.cc/RZdG5Yvq/arbitrum-layer-2-nitro-upgrade-goes-live-ahead-of-ethereum-merge-900x478.jpg"width="900"/></a>
</p>

# In this guide we will setup Arbitrum testnet RPC node.

#### Flollowing parametrs:
- 2 CPU 
- 4 GB RAM
- 600 GB SSD

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

## 2. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 3. Install docker and docker-compose
Check the latest version of [docker-compose](https://github.com/docker/compose/releases) and follow the guide.
```
sudo apt install docker.io -y
git clone https://github.com/docker/compose
cd compose
latestTag=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make 
cd ~
sudo mv compose/bin/build/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo docker-compose version
```
## 4. Install and Start Arbitrum testnet node
First check latest realiease. In our case the [latest release](https://github.com/OffchainLabs/nitro/tags) is `offchainlabs/nitro-node:v2.1.1-e9d8842`
```
RELEASE="offchainlabs/nitro-node:v2.1.1-e9d8842"
mkdir -p $HOME/data/arbitrum
chmod -fR 777 $HOME/data/arbitrum
```
Input your URL address started from `htttp://123` or link from [infura](https://www.infura.io/).
```
ETH_RPC_URL="http://123....:8545 or link from infura"
```
```
echo "export ETH_RPC_URL=${ETH_RPC_URL}" >> .bash_profile
source .bash_profile
```
```
sudo docker run --name arbitrum --restart unless-stopped --stop-timeout 300 -it -d -v $HOME/data/arbitrum:/home/user/.arbitrum -p 0.0.0.0:8550:8547 -p 0.0.0.0:8549:8548 $RELEASE --parent-chain.connection.url $ETH_RPC_URL --chain.id=421613 --http.api=net,web3,eth,debug --http.corsdomain=* --http.addr=0.0.0.0 --http.vhosts=*
```
Check your logs: 
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

## 7. Upgrade your Arbitrum node
First check latest realiease. In our case the [latest release](https://github.com/OffchainLabs/nitro/tags) is `offchainlabs/nitro-node:v2.0.14-2baa834`
```
RELEASE="offchainlabs/nitro-node:v2.1.1-e9d8842"
```
```
echo $RELEASE
sudo docker stop arbitrum
sudo docker rm arbitrum
```
```
sudo docker run --name arbitrum --restart unless-stopped --stop-timeout 300 -it -d -v $HOME/data/arbitrum:/home/user/.arbitrum -p 0.0.0.0:8550:8547 -p 0.0.0.0:8549:8548 $RELEASE --parent-chain.connection.url $ETH_RPC_URL --chain.id=421613 --http.api=net,web3,eth,debug --http.corsdomain=* --http.addr=0.0.0.0 --http.vhosts=*
```

## 8. Delete your Arbitrum node
```
sudo docker down -w
sudo docker kill arbitrum
sudo docker rm arbitrum
sudo rm -rf data
```
#

👉[Webtropia — server rental](https://bit.ly/45KaUj4)

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
