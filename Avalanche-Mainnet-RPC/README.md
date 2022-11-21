<p align="center">
 <img src="https://i.ibb.co/fqcYJXC/Avalanche.jpg"/></a>
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

## 3. Node installation.
```
git clone https://github.com/ava-labs/avalanchego
cd avalanchego
```
```
mkdir build
cd build
```
Check the latest [release](https://github.com/ava-labs/avalanchego/tags). At the time of writing this guide, the latest release is `1.9.3`
```
wget https://github.com/ava-labs/avalanchego/releases/download/v1.9.3/avalanchego-linux-amd64-v1.9.3.tar.gz
tar -xvzf avalanchego-linux-amd64-v1.9.3.tar.gz
```
```
mv avalanchego-v1.9.3 avalanchego-launch
rm -rf avalanchego-linux-amd64-v1.9.3.tar.gz
cd ~ 
```

## 4. Launch a node
```
tee /etc/systemd/system/avaxd.service > /dev/null <<EOF

[Unit]
Description=Avalanche
After=network-online.target

[Service]
User=root
ExecStart=/root/avalanchego/build/avalanchego-launch/avalanchego
Restart=always
RestartSec=3
LimitNOFILE=40000
[Install]

WantedBy=multi-user.target
EOF
```
```
systemctl daemon-reload
systemctl enable avaxd
systemctl start avaxd
```
Check logs
```
journalctl -fu avaxd -o cat -n 100
```
Wait for full synchronization. It will take approximately 5 days.

#
👉[Webtropia](https://www.webtropia.com/?kwk=255074042020228216158042)

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
