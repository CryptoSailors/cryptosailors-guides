<p align="center">
 <img src="https://i.postimg.cc/RZdG5Yvq/arbitrum-layer-2-nitro-upgrade-goes-live-ahead-of-ethereum-merge-900x478.jpg"width="900"/></a>
</p>

# In this guide we will setup zkPolygon testnet RPC node.

#### Flollowing parametrs:
- 4 CPU 
- 16 GB RAM
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

## 4. Install and Start zkPolygon testnet node
```
git clone https://github.com/0xPolygonHermez/zkevm-node
cd zkevm-node
git fetch --all
latestTag=$(curl -s https://api.github.com/repos/0xPolygonHermez/zkevm-node/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
sudo make build-docker
```
Start your testnet node
```
cd test
sudo make run
```
To check your logs you should run command bellow in folder `/zkevm-node/test`
```
sudo docker-compose logs -f --tail 100 zkevm-sync
```

## 5. Link to your RPC
- `http://YOUR_IP:8545`

## 6. Delete your zkPolygon testnet node
```
cd zkevm-node/test
sudo make stop
cd ~
sudo rm -rf zkevm-node
```
#

👉[Webtropia — server rental](https://bit.ly/45KaUj4)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[zkPolygon Official docs](https://wiki.polygon.technology/docs/zkevm/setup-local-node/)

👉[zkPolygon Github](https://github.com/0xPolygonHermez/zkevm-node)

👉[ZkPolygon Testnet Explorer](https://testnet-zkevm.polygonscan.com/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
