<p align="center">
 <img src="https://i.postimg.cc/PrQY2zQz/68747470733a2f2f692e706f7374696d672e63632f4c35444348356d6b2f426173652d426c6f672d6865616465722e706e67.png"width="900"/></a>
</p>

# In this guide we will setup Base mainnet RPC node.

#### Flollowing parametrs:

- 8 CPU
- 16 GBRAM
- 4 TB SSD

#### My Recommendations

- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4) with extended SSD or NVME disk.
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 1. Node Preparation.
```
sudo adduser base
sudo usermod -aG sudo base
sudo su - base
```
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```

## 2. Install golang Go.

Install Golang go according step 2 of [this instruction](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22).

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

## 4. Install and configure Base mainnet node

```
git clone https://github.com/base-org/node
cd node
```
Open a `.env.mainnet`. Find `OP_NODE_L1_ETH_RPC` and `OP_NODE_L1_BEACON`. Input your Ethereum and Beacon RPC url.
```
sudo nano .env.mainnet
```
#### Example:

```
# [recommended] replace with your preferred L1 (Ethereum, not Base) node RPC URL:
OP_NODE_L1_ETH_RPC=http://YOUR_ETHEREUM_RPC_IP:PORT

# [required] replace with your preferred L1 CL beacon endpoint:
OP_NODE_L1_BEACON=http://YOUR_BEACON_RPC_IP:PORT
```
Open a `docker-compose.yml` chose mainnet network and input your data volume.
```
sudo nano docker-compose.yml
```
#### Example:

```
version: '3.8'

services:
  geth: # this is Optimism's geth client
    build: .
    ports:
      - 8545:8545       # RPC
      - 8546:8546       # websocket
      - 30303:30303     # P2P TCP (currently unused)
      - 30303:30303/udp # P2P UDP (currently unused)
      - 7301:6060       # metrics
    command: [ "bash", "./geth-entrypoint" ]
    volumes:
        - 'home/base/node/data:/data
    env_file:
      # select your network here:
#      - .env.sepolia
      - .env.mainnet
  node:
    build: .
    depends_on:
      - geth
    ports:
      - 7545:8545     # RPC
      - 9222:9222     # P2P TCP
      - 9222:9222/udp # P2P UDP
      - 7300:7300     # metrics
      - 6060:6060     # pprof
    command: [ "bash", "./op-node-entrypoint" ]
    env_file:
      # select your network here:
#      - .env.sepolia
      - .env.mainnet
```

## 5. Downoald latest snapshot

I recommend launch `tmux` or `screen` windows, because downloading of [shanpshot](https://docs.base.org/guides/run-a-base-node) will take about 10h.
```
cd ~
wget https://mainnet-full-snapshots.base.org/$(curl https://mainnet-full-snapshots.base.org/latest) -O - | tar -xz -C $HOME/node
```
```
sudo mkdir $HOME/node/data
sudo sudo mv $HOME/node/snapshots/mainnet/download/geth $HOME/node/data
```

## 6. Start a Base mainnet node.
```

sudo docker-compose build
sudo docker-compose up -d
```

## 7. Check you node. 

- To check logs of your node you should be in folder `node`:
```
sudo docker-compose logs -f --tail 100
```
- You can monitor the progress of your sync with:
```
echo Latest synced block behind by: $((($(date +%s)-$( \
  curl -d '{"id":0,"jsonrpc":"2.0","method":"optimism_syncStatus"}' \
  -H "Content-Type: application/json" http://localhost:7545 | \
  jq -r .result.unsafe_l2.timestamp))/60)) minutes
  ```
  
## 8. Link on your rpc:

- `http://YOUR_IP:8549`

## 9. Update your Base mainnet node:

```
cd node
sudo docker-compose stop
sudo cp docker-compose.yml docker-compose.yml_backup
sudo cp .env.mainnet .env.mainnet_backup
git reset --hard
git pull
```
Configure your `docker-compose.yml` and `.env.goerli` from step 4 and launch a node.
```
sudo cp -r .env.mainnet_backup .env.mainnet
sudo cp -r docker-compose.yml_backup docker-compose.yml
sudo docker-compose build
sudo docker-compose up -d
```
Whait about 10 min. and then check your logs:
```
sudo docker-compose logs -f --tail 100
```

## 10. Delete your node

```
sudo su - base
cd node
sudo docker-compose down -v
cd ~
exit
sudo rm -rf /home/base
sudo userdel base
```

#
👉[Webtropia — server rental](https://bit.ly/45KaUj4)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Base Official docs](https://docs.base.org/guides/run-a-base-goerli-node)

👉[Base Explorer](https://basescan.org/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

**Guide created by**

Pavel-LV | C.Sailors#7698 / @SeaInvestor
