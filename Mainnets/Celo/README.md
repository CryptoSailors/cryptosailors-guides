<p align="center">
 <img src="https://i.postimg.cc/pXw1VLHF/image-1-e1654805913123-pq2rm33wk75eh3zwzct9mc7kzndrp61mkfl3rfrnyo.png"width="900"/></a>
</p>

# In this guide we will setup Celo mainnet node RPC.

#### Flollowing parametrs:
- 4 CPU (16 threads)
- 8 GB RAM
- 250 GB SSD

#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 1. Node Preparation.
```
sudo adduser celo
sudo usermod -aG sudo celo
sudo su - celo
```
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

## 4. Install and configure Celo mannet node
```
echo "export CELO_IMAGE=us.gcr.io/celo-org/geth:mainnet" >> $HOME/.profile
source $HOME/.bash_profile
```
```
sudo docker pull $CELO_IMAGE
```
```
sudo docker run -v $PWD:/$HOME/.celo --rm -it $CELO_IMAGE account new
```
You will get a public address of the key
```
echo "export CELO_ACCOUNT_ADDRESS=<YOUR-ACCOUNT-ADDRESS>" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

#### Download and unpack celo mainnet snapshot
```
wget https://storage.googleapis.com/celo-chain-backup/mainnet/chaindata-latest.tar.lz4
```
``` 
lz4 -c -d chaindata-latest.tar.lz4  | tar -x -C $HOME/celo
```

## 5. Start a celo mainnet node.
```
sudo docker run --name celo-fullnode -d --restart unless-stopped --stop-timeout 300 -p 0.0.0.0:8911:8545 -p 0.0.0.0:8912:8546 -p 30305:30303 -p 30306:30303/udp -v $PWD:$HOME/.celo $CELO_IMAGE --verbosity 3 --syncmode full --http --http.addr 0.0.0.0 --http.api eth,net,web3,debug,admin,personal --light.serve 90 --light.maxpeers 1000 --maxpeers 1100 --etherbase $CELO_ACCOUNT_ADDRESS --datadir $HOME/.celo
```
To check logs of your node:
```
sudo docker logs celo-fullnode -f --tail 100
```

## 6. Upgrade your celo fullnode
```
CELO_IMAGE=us.gcr.io/celo-org/geth:1.8.2
sudo docker stop -t 300 celo-fullnode
sudo docker rm celo-fullnode
sudo docker pull $CELO_IMAGE
sudo docker run --name celo-fullnode -d --restart unless-stopped --stop-timeout 300 -p 0.0.0.0:8911:8545 -p 0.0.0.0:8912:8546 -p 30305:30303 -p 30306:30303/udp -v $PWD:$HOME/.celo $CELO_IMAGE --verbosity 3 --syncmode full --http --http.addr 0.0.0.0 --http.api eth,net,web3,debug,admin,personal --light.serve 90 --light.maxpeers 1000 --maxpeers 1100 --etherbase $CELO_ACCOUNT_ADDRESS --datadir $HOME/.celo
```
## 7. Link on your rpc:

- `http://YOUR_IP:8911`

## 8. Delete a node
```
sudo docker stop celo-fullnode
sudo docker rm celo-fullnode
sudo docker kill celo-fullnode
sudo rm -rf celo
```
#

👉[Webtropia — server rental](https://bit.ly/45KaUj4)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Celo Official docs](https://docs.celo.org/network/node/run-mainnet)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
