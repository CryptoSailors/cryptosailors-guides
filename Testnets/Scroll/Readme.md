<p align="center">
 <img src="https://i.postimg.cc/wBzNz3Kf/Scroll-Logo-Large-scaled.jpg"width="900"/></a>
</p>

# In this guide we will setup Scroll testnet RPC node.

#### Flollowing parametrs:
- 8 CPU 
- 32 GB RAM
- 1TB+ SSD

#### My Recommendations
- I recommend Dedicated Ryzen 7 Server on [webtropia](https://bit.ly/45KaUj4)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 1. Node Preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```

## 2. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 3. Install and start Scroll mainnet node
```
L1_ENDPOINT="http://YOUR_ETH_SEPOLIA_NODE:PORT"
echo "export L1_ENDPOINT=${L1_ENDPOINT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
git clone https://github.com/scroll-tech/go-ethereum l2geth-source
cd l2geth-source
latestTag=$(curl -s https://api.github.com/repos/scroll-tech/go-ethereum/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
git branch
make nccc_geth
./build/bin/geth version
```

## 4. Create a systemd file and launch a node
```
sudo tee <<EOF >/dev/null /etc/systemd/system/scroll.service
[Unit]
Description=geth daemon
After=network-online.target

[Service]
User=$USER
ExecStart=/home/scroll/l2geth-source/build/bin/geth --scroll-sepolia \
--datadir "./l2geth-datadir" \
--gcmode archive \
--cache.noprefetch \
--http \
--http.addr "0.0.0.0" \
--http.port 8491 \
--http.api "eth,net,web3,debug,scroll" \
--l1.endpoint "$L1_ENDPOINT" \
--l1.confirmations "finalized" \
--datadir $HOME/.scroll \
--http.vhosts "*" \
--ws \
--ws.origins '*' \
--ws.addr 0.0.0.0 \
--ws.port 8492 \
--port "30317"

Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable scroll
sudo systemctl start scroll
sudo journalctl -u scroll -f -n 100 -o cat
```

## 5 Your RPC url are:

- `http://YOUR_IP:8491`
- `ws://YOUR_IP:8492`

## 6. Upgrade your Scroll node
First check latest realiease. In our case the [latest release](https://github.com/scroll-tech/go-ethereum/releases)
```
cd l2geth-source
git pull
latestTag=$(curl -s https://api.github.com/repos/scroll-tech/go-ethereum/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
git branch
make nccc_geth
./build/bin/geth version
```

## 7. Delete your node
```
sudo systemctl disable scroll
sudo systemctl stop scroll
sudo rm -rf /etc/systemd/system/scroll.service
sudo rm -rf l2geth-source
sudo rm -rf .scroll
```

👉[Webtropia — server rental](https://bit.ly/45KaUj4)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Scroll Website](https://scroll.io/)

👉[Scroll Official docs](https://docs.scroll.io/en/home/)

👉[Scroll Github](https://github.com/scroll-tech/go-ethereum)

👉[Scroll Sepolia Explorer](https://sepolia.scrollscan.com/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
