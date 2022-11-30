<p align="center">
 <img src="https://miro.medium.com/max/4800/0*cPIHLySQDKIxbaHC.webp"/></a>
</p>

# In this Guide we will install a Chainflip testnet node.

## 1. Requirements.
Official 
- 4 CPU
- 8 GB RAM
- 50 GB SSD
#### My Recomandation
- Install it on Ubuntu 20.04. There are problems with Ubuntu 22.04
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://www.webtropia.com/?kwk=255074042020228216158042)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
```
sudo apt install gpg -y
```
```
sudo apt install logrotate
```

## 3. Node installation.
```
sudo mkdir -p /etc/apt/keyrings
```
```
curl -fsSL repo.chainflip.io/keys/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/chainflip.gpg
```
You should see output:
```
pub   rsa3072 2022-11-08 [SC] [expires: 2024-11-07]
      BDBC3CF58F623694CD9E3F5CFB3E88547C6B47C6
uid                      Chainflip Labs GmbH <dev@chainflip.io>
sub   rsa3072 2022-11-08 [E] [expires: 2024-11-07]
```

## 3.1 Installing the necessary packages
```
echo "deb [signed-by=/etc/apt/keyrings/chainflip.gpg] https://repo.chainflip.io/perseverance/ focal main" | sudo tee /etc/apt/sources.list.d/chainflip.list
```
```
sudo apt-get update
```
```
sudo apt-get install -y chainflip-cli chainflip-node chainflip-engine
```
## 4. Creating keys for ETH
Use [Metamask](https://metamask.io/) to create a new wallet and pull the private key from it. This new wallet will participate in the current testnet. Connect to [Goerli (Görli) network](https://blog.cryptostars.is/goerli-g%C3%B6rli-testnet-network-to-metamask-and-receiving-test-ethereum-in-less-than-2-min-de13e6fe5677) and request 0.2 ETH to your new wallet through [Faucet](https://goerli-faucet.pk910.de/).
```
sudo mkdir /etc/chainflip/keys
```
Replace `YOUR_VALIDATOR_WALLET_PRIVATE_KEY` with the new private key you created.
```
echo -n "YOUR_VALIDATOR_WALLET_PRIVATE_KEY" |  sudo tee /etc/chainflip/keys/ethereum_key_file
```

## 4.1 Creating keys for Chainflip
```
chainflip-node key generate
```
You should get an output like in the picture below. Be sure to save it!

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*Ti0i3A7hyw1rQ5xVv3iznQ.webp"/></a>
</p>

We make a variable and add a ChainFlip address. Insert secret seed instead `YOUR_CHAINFLIP_SECRET_SEED`
```
SECRET_SEED=YOUR_CHAINFLIP_SECRET_SEED
```
```
echo -n "${SECRET_SEED:2}" | sudo tee /etc/chainflip/keys/signing_key_file
```
## 4.2 Generating a NodeKey.
```
sudo chainflip-node key generate-node-key --file /etc/chainflip/keys/node_key_file
```
After command bellow make sure that you save output in save place!
```
cat /etc/chainflip/keys/node_key_file
```
## 5 5. Setting up our node
First you need to go to [Infura](https://app.infura.io/login), and create a project in Goerli. Then take out two addresses (HTTPS and WEBSOCKETS), which you then have to insert in the editor. Follow the pictures.

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*5i9zgkbFi-7XpRQwowwESQ.webp"/></a>
</p>

<p align="center">
 <img src="https://miro.medium.com/max/720/1*Ld1g5z3C1R4O3yfqmwcD4A.webp"/></a>
</p>

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*6fE-S7eNsoQsuJU6ty7yjA.webp"/></a>
</p>

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*COXTGXY_HUnDbvCRuua1lw.webp"/></a>
</p>

Infura will give us two Endpoints. Now we need to insert them into the file and run the node.
```
sudo mkdir -p /etc/chainflip/config
```
```
sudo nano /etc/chainflip/config/Default.toml
```
This will open an editor where you must paste everything below and edit the file. Replace the following lines:

- `IP_ADDRESS_OF_YOUR_NODE` to the IP address of your server.
- `WSS_ENDPOINT_FROM_ETHEREUM_CLIENT` to what Infura suggests in the WSS Endpoint line
- `HTTPS_ENDPOINT_FROM_ETHEREUM_CLIENT` to what Infura suggests in the RPC Endpoint line
```
# Default configurations for the CFE
[node_p2p]
node_key_file = "/etc/chainflip/keys/node_key_file"
ip_address="IP_ADDRESS_OF_YOUR_NODE"
port = "8078"

[state_chain]
ws_endpoint = "ws://127.0.0.1:9944"
signing_key_file = "/etc/chainflip/keys/signing_key_file"

[eth]
# Ethereum RPC endpoints (websocket and http for redundancy).
ws_node_endpoint = "WSS_ENDPOINT_FROM_ETHEREUM_CLIENT"
http_node_endpoint = "HTTPS_ENDPOINT_FROM_ETHEREUM_CLIENT"

# Ethereum private key file path. This file should contain a hex-encoded private key.
private_key_file = "/etc/chainflip/keys/ethereum_key_file"

[signing]
db_file = "/etc/chainflip/data.db"
```
Save the changes with CTRL+X,Y,Enter.

#
👉[Webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[WebSite](https://www.avax.network/community)

👉[Official guide](https://docs.avax.network/nodes/build/run-avalanche-node-manually)

👉[Github](https://github.com/ava-labs)

👉[Avalanche Explorer](https://snowtrace.io/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
