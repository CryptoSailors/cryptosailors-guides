<p align="center">
 <img src="https://i.postimg.cc/ffhGhwmGky/Untitled-1200-630-px.png"width="900"/></a>
</p>

# In this guide we will setup Optimism testnet RPC node.

#### Flollowing parametrs:
- 8 CPU 
- 16 GB RAM
- 200 GB SSD

## 1. Node Preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
## 2. Install golang go.
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 3. Install docker and docker-compose
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
docker-compose version
```
## 4. Install and configure Optimism node
```
git clone https://github.com/smartcontracts/simple-optimism-node.git
cd simple-optimism-node
cp .env.example .env
```
Now we need open a .env file and do configuration.
```
sudo nano .env
```
You should edit following items:
- NETWORK_NAME
- HEALTHCHECK__REFERENCE_RPC_PROVIDER
- FAULT_DETECTOR__L1_RPC_PROVIDER
- DATA_TRANSPORT_LAYER__RPC_ENDPOINT
- OP_NODE__RPC_ENDPOINT
```
###############################################################################
#                                ↓ REQUIRED ↓                                 #
###############################################################################

# Network to run the node on ("mainnet" or "goerli")
NETWORK_NAME=goerli

# Type of node to run ("full" or "archive"), note that "archive" is 10x bigger
NODE_TYPE=full

# Password for the qBittorrent UI
TORRENT_UI_PASSWORD=adminadmin

###############################################################################
#                            ↓ REQUIRED (LEGACY) ↓                            #
###############################################################################

# Where to sync data from ("l1" or "l2"), see README
SYNC_SOURCE=l1

# Reference L2 node to run healthcheck against
HEALTHCHECK__REFERENCE_RPC_PROVIDER=https://mainnet.optimism.io/

# L1 node to run fault detection against
FAULT_DETECTOR__L1_RPC_PROVIDER=<YOUR_GOERLI_ETHEREUM_RPC>

# Node to get chain data from (if SYNC_SOURCE is "l1" then use L1 node, etc.)
DATA_TRANSPORT_LAYER__RPC_ENDPOINT=<YOUR_GOERLI_ETHEREUM_RPC>

###############################################################################
#                            ↓ REQUIRED (BEDROCK) ↓                           #
###############################################################################

# Where to get the Bedrock database ("download" or "migration"), see README
BEDROCK_SOURCE=download

# L1 node that the op-node (Bedrock) will get chain data from
OP_NODE__RPC_ENDPOINT=<YOUR_GOERLI_ETHEREUM_RPC>

# Type of RPC that op-node is connected to, see README
OP_NODE__RPC_TYPE=basic
```
To close redactor press CTRL+X,Y,ENTER

## 5. Launch a node
To start an Optimism node you should be inside folder `simple-optimis-node`
```
sudo docker-compose up -d
```
Check all logs
```
sudo docker-compose logs -f --tail 100
```
Check geth logs
```
sudo docker-compose logs op-geth -f --tail 100
```
Chekc Optimism node logs
```
sudo docker-compose logs op-node -f --tail 100
```
Check l2geth logs
```
sudo docker-compose logs l2geth -f --tail 100
```
## Verify your node status.
Input command bellow to verify,that you configure node correctly.
```
curl -X POST $(curl -4 ifconfig.co):9991 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq
```
If you get something like this in response to the above rpc call, your node is setup correctly:
```
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x62ca4"
}
```
Also you can check the status of your synchrinization process. If they will show `false` that mean that you are synched.
```
curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "eth_blockNumber","params": []}' localhost:9991
```



































