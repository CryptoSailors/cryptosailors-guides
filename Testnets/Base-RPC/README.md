<p align="center">
 <img src="https://i.postimg.cc/L5DCH5mk/Base-Blog-header.png"width="900"/></a>
</p>

# In this guide we will setup Base testnet RPC node.

#### Flollowing parametrs:

- 4 CPU
- 16 GB RAM
- 1TB SSD

#### My Recommendations

- I recommend Dedicated Ryzen 5 Server on [webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) with extended SSD or NVME disk.
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 1. Node Preparation.

```
sudo adduser base
sudo usermod - aG sudo base
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

## 4. Install and configure Base testnet node

```
git clone https://github.com/base-org/node
cd node
```
Open a `.env.goerli`. Find `OP_NODE_L1_ETH_RPC` and `OP_NODE_L1_BEACON` input your Ethereum Goerli RPC and beacon url.
```
sudo nano .env.goerli
```
#### Example:
```
# [recommended] replace with your preferred L1 (Ethereum, not Base) node RPC URL:
OP_NODE_L1_ETH_RPC=http://YOUR_GOERLI_IP:PORT
```
```
# [required] replace with your preferred L1 CL beacon endpoint:
OP_NODE_L1_BEACON=http://YOUR_GOERLI_IP:PORT
```
Open a `docker-compose.yml` and chose goerli network. And add volume folder.
```
sudo nano docker-compose.yml
```

#### Example:

```
version: '3.8'

services:
  geth: # this is Optimism's geth client
    build: .
    volumes:
      - /home/base/node/data:/data
    ports:
      - 8546:8545       # RPC
      - 8552:8546       # websocket
      - 30306:30303     # P2P TCP (currently unused)
      - 30306:30303/udp # P2P UDP (currently unused)
      - 7305:6060       # metrics
    command: [ "bash", "./geth-entrypoint" ]
    env_file:
      # select your network here:
      - .env.goerli
#      - .env.sepolia
#      - .env.mainnet
  node:
    build: .
    depends_on:
      - geth
    ports:
      - 7545:8545     # RPC
      - 9222:9222     # P2P TCP
      - 9222:9222/udp # P2P UDP
      - 7304:7300     # metrics
      - 6161:6060     # pprof
    command: [ "bash", "./op-node-entrypoint" ]
    env_file:
      # select your network here:
      - .env.goerli
#      - .env.sepolia
#      - .env.mainnet
```

## 5. Downoald latest snapshot

I recommend launch `tmux` or `screen` windows, because downloading of [shanpshot](https://docs.base.org/guides/run-a-base-node) will take about 7h.
```
cd ~
wget https://base-goerli-archive-snapshots.s3.us-east-1.amazonaws.com/$(curl https://base-goerli-archive-snapshots.s3.us-east-1.amazonaws.com/latest) -O - | tar -xz -C $HOME/node
```

## 6. Start a Base testnet node.

```
cd node
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
  
## 7. Link on your rpc:

- `http://YOUR_IP:8546`

## 8. Update your Base testnet node:

```
cd node
sudo docker-compose stop
git reset --hard
git pull
```
Configure your `docker-compose.yml` and `.env.goerli` from step 4 and launch a node.
```
sudo docker-compose build
sudo docker-compose up -d
```
Whait about 10 min. and then check your logs:
```
sudo docker-compose logs -f --tail 100
```
#

👉[Webtropia — server rental](https://bit.ly/45KaUj4)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Base Official docs](https://docs.base.org/guides/run-a-base-goerli-node)

👉[Base Goerli Explorer](https://goerli.basescan.org/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
