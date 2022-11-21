<p align="center">
 <img src="https://i.ibb.co/fqcYJXC/Avalanche.jpg"/></a>
</p>

# In this Guide we will install a Avalanche mainnet node as an RPC

## 1. Requirements.
Official 
- 4 CPU
- 16 GB RAM
- 1000 GB SSD
- I recommend hosting [netcup.eu](https://www.netcup.eu/bestellen/produkt.php?produkt=2902)- with coupon new users will get discount of 5 EU - 36nc16679836760
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

```
git clone https://github.com/ava-labs/avalanchego
cd avalanchego
```
```
mkdir build
cd build
```
```
wget https://github.com/ava-labs/avalanchego/releases/download/v1.9.3/avalanchego-linux-amd64-v1.9.3.tar.gz
tar -xvzf avalanchego-linux-amd64-v1.9.3.tar.gz
```
```
mv avalanchego-v1.9.3 avalanchego-launch
rm -rf avalanchego-linux-amd64-v1.9.3.tar.gz
cd ~ 
```
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
```
journalctl -fu avaxd -o cat -n 100
```
























































#
👉[NetCup](https://www.netcup.eu/bestellen/produkt.php?produkt=2902)- with coupon new users will get discount of 5 EU - `36nc16679836760`

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.com/invite/UchwUrgbjy) 

👉[WebSite](https://gitopia.com/)

👉[Official guide](https://docs.gitopia.com/validator-overview)

👉[Gitopia](https://gitopia.com/gitopia/gitopia/releases)

👉[Gitopia Explorer](https://explorer.gitopia.com/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
