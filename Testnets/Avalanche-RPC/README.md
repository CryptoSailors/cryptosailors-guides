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

## 4. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.


## 4. Node installation.
```
git clone https://github.com/ava-labs/avalanchego
cd avalanchego
./scripts/build.sh
cd ~
```

## 5. Launch a node
```
sudo tee /etc/systemd/system/avalanchego.service > /dev/null <<EOF
[Unit]
Description=AvalancheGo systemd service
StartLimitIntervalSec=0
[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=$HOME/avalanchego/build/avalanchego \
 --network-id=fuji \
 --http-host 0.0.0.0

LimitNOFILE=32768
Restart=always
RestartSec=1
[Install]
WantedBy=multi-user.target
```
```
sudo systemctl enable avalanchego
sudo systemctl daemon-reload
sudo systemctl restart avalanchego
sudo journalctl -u avalanchego -f -n 100
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
