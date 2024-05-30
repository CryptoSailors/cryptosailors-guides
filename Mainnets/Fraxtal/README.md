<p align="center">
 <img src="https://i.postimg.cc/g0vQBF37/frax-finance.png"/></a>
</p>

# In this guide we will install a Fraxtal Mainnet RPC node.

## 1. Requirements.

#### Official 
- 8 CPU or more
- 8 GB RAM
- 500 GB SSD
  
#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).


## 2. Create a user
```
sudo adduser fraxtal
```
```
sudo usermod -aG sudo fraxtal
sudo usermod -aG systemd-journal fraxtal
```
```
sudo su - fraxtal
```
 
## 3. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
## 4. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 5. Install docker and docker compose.
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

## 6. Install a Fraxtal node
```
git clone https://github.com/FraxFinance/fraxtal-node.git
cd fraxtal-node
```

## 7. Configure your node
```
echo export ENVIRONMENT=mainnet >> $HOME/.bash_profile
echo export DOCKER_COMPOSE_FILE_LOCATION=$HOME/fraxtal-node/docker-compose.yml >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
cp .env.SAMPLE .env
```
Input your Ethereum RPC node in `.env` file.
```
sudo nano .env
```
```
# Your Ethereum RPC node endpoint. As an L2, your Frax node will verify tx finality by
# querying your own Ethereum RPC node.
OP_NODE_L1_ETH_RPC=http://YOUR_ETHEREUM_RPC:PORT
OP_NODE_L1_BEACON=http://YOUR_ETHEREUM_BEACON_RPC:PORT

```
If you have several nodes on one machine, you can configure your `docker-compose.yml` like me bellow. Just copy and past in your `docker-compose.yml`
```
sudo nano docker-compose.yml
```
```
version: "3.8"

services:
  mainnet-geth:
    image: us-docker.pkg.dev/oplabs-tools-artifacts/images/op-geth:v1.101315.0
    ports:
      - 8534:8545
      - 8535:8546
      - 30303:30303/tcp
      - 30303:30303/udp
    entrypoint: ["geth-entrypoint"]
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8545"]
      interval: 5s
      timeout: 10s
      retries: 100
    env_file: .env
    volumes:
      - ./mainnet/data/op-geth:/data
      - ./mainnet/genesis.json:/data/genesis.json:ro
      - ./geth-entrypoint.sh:/bin/geth-entrypoint
  mainnet-node:
    image: ghcr.io/fraxfinance/fraxtal-op-node:v1.7.5-frax-1.1.0
    ports:
      - 7390:8545
      - 9346:9222/tcp
      - 9346:9222/udp
    entrypoint: ["node-entrypoint"]
    depends_on:
      mainnet-geth:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8545"]
      interval: 5s
      timeout: 10s
      retries: 100
    env_file: .env
    volumes:
      - ./mainnet/rollup.json:/data/rollup.json:ro
      - ./node-entrypoint.sh:/bin/node-entrypoint
```
                                         
## 8. Start your Fraxtal node
```
sudo docker-compose -f $DOCKER_COMPOSE_FILE_LOCATION up -d
```
Check your logs
```
sudo docker-compose -f $DOCKER_COMPOSE_FILE_LOCATION logs $ENVIRONMENT-node --since 2m -f
```
```
sudo docker-compose -f $DOCKER_COMPOSE_FILE_LOCATION logs $ENVIRONMENT-geth --since 2m -f
```

## 9. Deleting a node
```
sudo docker-compose stop $DOCKER_COMPOSE_FILE_LOCATION
sudo docker-compose down $DOCKER_COMPOSE_FILE_LOCATION -v
exit
```
```
sudo userdel fraxtal
sudo rm -rf /home/fraxtal
```

## 10. Your RPC URL

- `http://YOUR_IP_ADDRESS:7390` 

#
👉[Webtropia](https://bit.ly/45KaUj4) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Fraxtal Github](https://github.com/FraxFinance/fraxtal-node)

👉[Fraxtal Explorer](https://fraxscan.com/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
