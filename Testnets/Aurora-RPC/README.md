<p align="center">
 <img src="https://i.postimg.cc/hGhwmGky/Untitled-1200-630-px.png"width="900"/></a>
</p>

# In this guide we will setup Aurora testnet RPC node.

#### Flollowing parametrs:
- 8 CPU (16 threads)
- 8 GB RAM
- 500 GB SSD

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
## 4.  Install and synch Aurora testnet node
```
git clone https://github.com/aurora-is-near/partner-relayer-deploy
cd partner-relayer-deploy
sudo ./setup.sh testnet
```
After unpacking, your node should start up on its own. To check logs proceed to folder `partner-relayer-deploy` and run command
```
sudo docker-compose logs -f --tail 100
```
#

👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Auorora Official docs](https://github.com/aurora-is-near/partner-relayer-deploy)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
