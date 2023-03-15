<p align="center">
 <img src="https://i.postimg.cc/pXw1VLHF/image-1-e1654805913123-pq2rm33wk75eh3zwzct9mc7kzndrp61mkfl3rfrnyo.png"width="900"/></a>
</p>

# In this guide we will setup Celo Alfajores testnet RPC node.

#### Flollowing parametrs:
- 4 CPU (16 threads)
- 8 GB RAM
- 250 GB SSD

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
## 3. Install and configure Celo testnet node
```
echo "export CELO_IMAGE=us.gcr.io/celo-org/geth:alfajores" >> $HOME/.profile
source $HOME/.bash_profile
```
```
sudo docker pull $CELO_IMAGE
```
```
mkdir celo-data-dir
cd celo-data-dir
sudo docker run -v $PWD:/$HOME/.celo --rm -it $CELO_IMAGE account new
```
You will get a public address of the key
```
echo "export CELO_ACCOUNT_ADDRESS=<YOUR-ACCOUNT-ADDRESS>" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## 4. Start a celo testnet node.
```
sudo docker run --name celo-fullnode -d --restart unless-stopped --stop-timeout 300 -p 0.0.0.0:8911:8545 -p 0.0.0.0:8912:8546 -p 30305:30303 -p 30305:30303/udp -v $PWD:$HOME/.celo $CELO_IMAGE --verbosity 3 --syncmode full --http --http.addr 0.0.0.0 --http.api eth,net,web3,debug,admin,personal --light.serve 90 --light.maxpeers 1000 --maxpeers 1100 --etherbase $CELO_ACCOUNT_ADDRESS --alfajores --datadir $HOME/.celo
```
To check logs of your node:
```
sudo docker logs celo-fullnode -f --tail 100
```

## 5. Link on your rpc:

- http://YOUR_IP:8911

#

👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Celo Official docs](https://docs.celo.org/network/node/run-alfajores)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
