<p align="center">
 <img src="https://i.postimg.cc/LsNKcDDB/Avalanche.jpg"/></a>
</p>

# In this Guide we will install a Avalanche mainnet node as an RPC

## 1. Requirements.
Official 
- 8 CPU
- 16 GB RAM
- 1000 GB SSD
#### My Recomandation
- I recommend Dedicated Ryzen 7 Server on [webtropia](https://www.webtropia.com/?kwk=255074042020228216158042)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
Instal Golang Go according [this instruction](https://github.com/CryptoSailors/Tools/tree/main/Install%20Golang%20%22Go%22)

## 3. Create your own user
```
sudo adduser avalanche
```
```
sudo usermod -aG sudo avalanche
```
```
usermod -a -G systemd-journal avalanche
```
```
sudo su - avalanche
```
```
cd ~
```

## 4. Node installation.
```
wget -nd -m https://raw.githubusercontent.com/ava-labs/avalanche-docs/master/scripts/avalanchego-installer.sh
chmod 755 avalanchego-installer.sh
```
```
./avalanchego-installer.sh
```
```
sudo systemctl status avalanchego
```
```
sudo journalctl -u avalanchego -f
```
## 5. Download latest snapshot
```
sudo mkdir temp
cd temp
```
Check the latest [snapshot here](http://186.233.187.26/)
```
sudo wget <INSERT_LINK_FROM DOWNLOAD>
```

## 6. Launch a node
```
tar -xf <avalanche_mainnet_....tar>
```
```
sudo systemctl stop avalanchego
```
```
cd ~
```
```
sudo mv /home/avalanche/.avalanchego/db /home/avalanche/.avalanchego/db_old
```
```
sudo mkdir /home/avalanche/.avalanchego/db
```
```
sudo mv /home/avalanche/temp/mainnet /home/avalanche/.avalanchego/db/
```
```
systemctl start avalanchego
```
```
systemctl enable avalanchego
```
```
journalctl -fu avalanchego -o cat -n 100
```
Check that logs works correctly whitout errors and finaly check status of our node.
```
curl -X POST --data '{"jsonrpc": "2.0","method": "info.isBootstrapped","params":{"chain":"C"},"id":1}' -H 'content-type:application/json;' localhost:9650/ext/info
```
If node show `{"jsonrpc":"2.0","result":{"isBootstrapped":true},"id":1}` that means that node are full synched.

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
