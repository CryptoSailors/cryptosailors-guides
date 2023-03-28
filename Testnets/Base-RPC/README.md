<p align="center">
 <img src="https://i.postimg.cc/L5DCH5mk/Base-Blog-header.png"width="900"/></a>
</p>

# In this guide we will setup Base testnet RPC node.

#### Flollowing parametrs:
- No official info.

## 1. Node Preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
Install Golang go according step 2 of [this instruction](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22).
## 2. Install docker and docker-compose
Check the latest version of [docker-compose](https://github.com/docker/compose/releases) and follow the guide.
```
sudo apt install docker.io -y
git clone https://github.com/docker/compose
cd compose
git checkout v2.17.2
make
cd ~
sudo mv compose/bin/build/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo docker-compose version
```
## 3. Install and configure Base testnet node
```
git clone https://github.com/base-org/node
cd node
```
Open a `docker-compose.yml`. Find `OP_NODE_L1_ETH_RPC` under `environment` and input your Ethereum Goerli RPC url.
```
sudo nano docker-compose.yml 
```
Example:
```
environment:
      - OP_NODE_L1_ETH_RPC=<YOUR_ETH_GOERLI_RPC_URL> # [recommended] replace wit.....
```
## 4. Start a Besu testnet node.
```
sudo docker-compose up -d
```
## 5. Check you node. 
- To check logs of your node you should be in folder `node`:
```
sudo docker-compose logs -f --tail 100
```
- Confirm you get a response from:
```
curl -d '{"id":0,"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",false]}' \
  -H "Content-Type: application/json" http://localhost:8545
```
The output should be something like this:
```
{"jsonrpc":"2.0","id":0,"result":{"baseFeePerGas":"0x31","difficulty":"0x0","extraData":"0x","gasLimit":"0x17d7840","gasUsed":"0x0","hash":"0xfbe2c722a66d5205a03a0f395
37defa198bf7198ee1ee68fb9e50240992f589a","logsBloom":"0x000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000","miner":"0x4200000000000000000000000000000000000011","mixHash":"0xdd4b86c2d64599f9492f292ebacce609
bfdcdf311b547baae2ffaa0ab92c4dfe","nonce":"0x0000000000000000","number":"0x25b2","parentHash":"0x9281b05e2560b94dca7e2479be50bd7db7880ddfc8067df44be3eb24e2f14317","rec
eiptsRoot":"0x3fd774ff8fe515813d7a8f9d3748e58e857bc002823a458a93be90a3bc2e0894","sha3Uncles":"0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347","size
":"0x363","stateRoot":"0x748a68b938e42a6b4ed411d84879a1d55742e4aebc9e1b3a2f250bcdda181fa1","timestamp":"0x63d9b874","totalDifficulty":"0x0","transactions":["0xa498d0b3
984ba6dedb6291de16196e6c583fe5cba4c584af470e7e9204935946"],"transactionsRoot":"0xfcc48032356ae3d83e237504a0f835afee5f0ddcda16c6201d99ecb06333bc3c","uncles":[]}}
```
- You can monitor the progress of your sync with:
```
echo Latest synced block behind by: $((($(date +%s)-$( \
  curl -d '{"id":0,"jsonrpc":"2.0","method":"optimism_syncStatus"}' \
  -H "Content-Type: application/json" http://localhost:7545 | \
  jq -r .result.unsafe_l2.timestamp))/60)) minutes
  ```
  
## 6. Link on your rpc:

- `http://YOUR_IP:8545`

#

👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Base Official docs](https://docs.base.org/guides/run-a-base-goerli-node)

👉[Base Goerli Explorer](https://goerli.basescan.org/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
