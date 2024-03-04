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

## 2. Create your own user
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

## 3. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
Instal Golang Go according [this instruction](https://github.com/CryptoSailors/Tools/tree/main/Install%20Golang%20%22Go%22)

## 4. Node installation.
```
wget -nd -m https://raw.githubusercontent.com/ava-labs/avalanche-docs/master/scripts/avalanchego-installer.sh
chmod 755 avalanchego-installer.sh
```
```
./avalanchego-installer.sh
```
```
sudo journalctl -u avalanchego -f
```
Now your node start sycnh mainnet chain. We should stop it and switch it to testnet.
```
sudo systemctl stop avalanchego
```
Open a  `node.json` in redactor and add a parametr `"network-id": "fuji"`
```
sudo nano /home/avalanche/.avalanchego/configs/node.json
```
```
{
  "http-host": "",
  "public-ip": "YOUR_IP_ADDRESS_HERE",
  "network-id": "fuji"
}
```
Close redactor by CTRX+X,Y,ENTER

## 5. Launch a node
```
sudo systemctl enable avalanchego
sudo systemctl daemon-reload
sudo systemctl restart avalanchego
sudo journalctl -u avalanchego -f -n 100
```
## 6. Updated a node
Most probably that you avalanche testnet node will be out of date. To fix it you need update it by last binary release. Checke the [latest release here](https://github.com/ava-labs/avalanchego/releases). In our case this is `v1.9.8` 
```
RELEASE=v1.9.8
echo $RELEASE
mkdir temp
cd temp
```
```
sudo wget https://github.com/ava-labs/avalanchego/releases/download/$RELEASE/avalanchego-linux-amd64-$RELEASE.tar.gz
```
```
sudo tar -xvzf avalanchego-linux-amd64-$RELEASE.tar.gz
```
```
sudo mv avalanchego-$RELEASE avalanche-node
sudo chmod +r avalanche-node
sudo systemctl stop avalanchego
```
```
sudo cp -r avalanche-node /home/avalanche
sudo systemctl start avalanchego
sudo journalctl -fu avalanchego -o cat -n 100
```
```
sudo rm -rf avalanchego-linux-amd64-$RELEASE.tar.gz
sudo rm -rf avalanche-node
```
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

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
