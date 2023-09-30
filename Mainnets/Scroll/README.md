<p align="center">
 <img src=""width="900"/></a>
</p>

# In this guide we will setup Scroll mainnet RPC node. (UNDER MAITANANCE)

#### Flollowing parametrs:
- 8 CPU 
- 32 GB RAM
- 1TB+ SSD
- 
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
L1_ENDPOINT="http://YOUR_ETH_MAINNET_NODE:PORT"
echo "export L1_ENDPOINT=${L1_ENDPOINT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
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

## 5. Upgrade your Scroll node
First check latest realiease. In our case the [latest release](https://github.com/scroll-tech/go-ethereum/releases)
```

```
## Delete your node
```

```
👉[Webtropia — server rental](https://bit.ly/45KaUj4)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Scroll Website](https://scroll.io/)

👉[Scroll Official docs]()

👉[Mantle Github](https://github.com/mantlenetworkio)

👉[Mantle Explorer](https://explorer.mantle.xyz/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)
