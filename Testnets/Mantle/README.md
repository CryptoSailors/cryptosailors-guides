<p align="center">
 <img src="https://i.postimg.cc/d3FCMXxk/depositphotos-159012884-stock-photo-fireflies-flying-in-the-forest.jpg"width="900"/></a>
</p>

# In this guide we will setup Mantle Testnet RPC node.

#### Flollowing parametrs:
- 4 CPU 
- 16 GB RAM
- 600+ GB SSD
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

- Install Golang go according step 2 of [this instruction.](https://github.com/CryptoSailors/cryptosailors-tools/blob/main/Install%20Golang%20%22Go%22/README.md)

## 2. Install docker and docker-compose
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
```
sudo usermod -a -G docker `whoami`
```
## 3. Install and start Mantle testnet node
```
sudo git clone https://github.com/mantlenetworkio/networks
cd networks
```
Install latest snapshot according [this instruction](https://github.com/mantlenetworkio/networks/blob/main/run-node.md#download-latest-snapshot-from-mantle). I recomend use tmux or screen for this operation. 

Configure `docker-compose.yml` and change link at `ETH1_HTTP` on your ETH Goerli RPC node. 
```
sudo nano docker-compose.yml
```
You also can change custom ports or your own if need it.
#### Example:
```
 ports:
      - ${VERIFIER_HTTP_PORT:-8625}:8545
      - ${VERIFIER_WS_PORT:-8626}:8546
```
#### CTRL+X,Y
```
sudo docker-compose up -d
```
Check your logs
```
sudo docker-compose logs replica -f --tail 100
```

## 4. Link to your RPC
- `http://YOUR_IP:8625`
- `ws://YOUR_IP:8626`

## 5. Upgrade your Mantle node
First check latest realiease. In our case the [latest release](https://github.com/mantlenetworkio/mantle/releases)
```
cd networks
docker-compose pull
```
## Delete your node
```
cd networks
sudo docker-compose down -v
cd ~
sudo rm -rf networks
```
👉[Webtropia — server rental](https://bit.ly/45KaUj4)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Mantle Website](https://www.mantle.xyz/)

👉[Mantle Official docs](https://docs.mantle.xyz/network/introduction/overview)

👉[Mantle Github](https://github.com/mantlenetworkio)

👉[Mantle Testnet Explorer](https://explorer.testnet.mantle.xyz/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
