# In this guide we will setup Fantom RPC node.

#### Flollowing parametrs:
- 4 CPU
- 16 GB RAM
- 1.5 TB SSD

## 1. Node Preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
## 2. Install golang go.
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 3. Install Fantom.
Make sure that you install the [latest release tag](https://github.com/Fantom-foundation/go-opera/tags). For example `v1.1.2-rc.5`
```
RELEASE=v1.1.2-rc.5
git clone https://github.com/Fantom-foundation/go-opera.git
cd go-opera
git checkout $RELEASE
make
```
```
cd build
wget https://download.fantom.network/testnet-6226-pruned-mpt.g
sudo chmod +x testnet-6226-pruned-mpt.g
sudo chmod +x opera
sudo mv opera /usr/bin
cd ~
```
## 4. Configure and launch Fantom testnet node.
```
sudo tee <<EOF >/dev/null /etc/systemd/system/fantom.service
[Unit]
Description=Fantom Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/bin --genesis /root/go-opera/build/testnet-6226-pruned-mpt.g --identity CryptoSailors --cache 8096 --http --http.addr 0.0.0.0 --http.corsdomain '*' --http.vhosts "*" --http.api "eth,net,web3" 
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
Start a fantom testnet node
```
sudo systemctl enable fantom
sudo systemctl daemon-reload
sudo systemctl start fantom
sudo journalctl -u fantom -f -n 100
```
                                                    
