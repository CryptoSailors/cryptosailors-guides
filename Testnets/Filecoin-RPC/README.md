<p align="center">
 <img src="https://i.postimg.cc/pLfCmhCM/143690-art-kosmos-nebo-cifrovoe-iskusstvo-zelenyj-1920x1080.jpg"width="900"/></a>
</p>

# In this guide we will setup Filecoin testnet RPC node.

#### Flollowing parametrs:
- 8 CPU 
- 32 GB RAM

## 1. Node Preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl clang build-essential hwloc libhwloc-dev wget aria2 -y && sudo apt upgrade -y
```
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
```
source "$HOME/.cargo/env"
```
## 2. Install Golang go
The Curent version don't support go version `v1.20` and latest. We will use `v1.19.12`
```
wget https://golang.org/dl/go1.19.12.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.12.linux-amd64.tar.gz
cat <<EOF >> ~/.bash_profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source ~/.bash_profile
go version
rm -rf go1.19.12.linux-amd64.tar.gz
```

## 3. Install and Start FileCoin testnet node
```
git clone https://github.com/filecoin-project/lotus.git
cd lotus/
git checkout releases
export RUSTFLAGS="-C target-cpu=native -g"
export FFI_BUILD_FROM_SOURCE=1
make clean calibnet
sudo make install
sudo make install-daemon-service
cd ~
```
## Install snapshot 
```
aria2c -x5 https://snapshots.calibrationnet.filops.net/minimal/latest.zst
```
input correct file path bellow 
```
sudo lotus daemon --import-snapshot /path/to/snapshot.zst --halt-after-import
```


## 4. Configure systemd file
```
sudo nano /etc/systemd/system/lotus-daemon.service
```
In the generated systemd file `/etc/systemd/system/lotus-daemon.service`, under `[Service]`,  add and set the `LOTUS_PATH` env variable to the config folder (e.g. `/home/ubuntu/.lotus`).
```
[Service]
Environment=LOTUS_PATH="/path/to/.lotus"
```
Save and close file `CTRL+X,Y,NETER`
## 5. Launch your node
```
sudo systemctl daemon-reload
sudo systemctl enable lotus-daemon
sudo systemctl start lotus-daemon
```
Check your logs 
```
sudo journalctl -u lotus-daemon -f -n 100 -o cat
```

## 6. Configure your node 
```
wget https://raw.githubusercontent.com/CryptoSailors/cryptosailors-guides/main/Testnets/Filecoin-RPC/config.toml
sudo chmod +x config.toml
sudo mv config.toml $HOME/.lotus
sudo systemctl restart lotus-daemon
sudo journalctl -u lotus-daemon -f -n 100 -o cat
```

## 7. Your RPC url
- `http:YOUR_IP:1234/rpc/v1`
#

👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[FileCoin Official docs](https://kb.factor8.io/docs/filecoin/testnets/hyperspace)

👉[FileCoin Github](https://github.com/filecoin-project/lotus)

👉[FileCoin Testnet Explorer](https://hyperspace.filfox.info/en/tipset)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
