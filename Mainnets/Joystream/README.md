<p align="center">
 <img src="https://i.postimg.cc/QxHnHwy7/Joystream-scaled.jpg"/></a>
</p>

# Joystream mainnet node guide installation.

## 1. Requirements.

#### Official 
- 4 CPU or more
- 8 GB RAM
- 100 GB SSD
  
#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Create a user
```
sudo adduser joystream
```
```
sudo usermod -aG sudo joystream
sudo usermod -aG systemd-journal joystream
```
```
sudo su - joystream
```

## 3. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
## 4. Install a node
```
git clone https://github.com/Joystream/joystream.git
```
```
cd joystream/
```
```
./setup.sh
```
```
WASM_BUILD_TOOLCHAIN=nightly-2022-05-11 cargo +nightly-2022-05-11 build --release
```

## 5. Crate a systemd file
```
sudo tee /etc/systemd/system/joystream.service > /dev/null <<EOF
[Unit]
Description=Joystream Node
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=$HOME/joystream/target/release/joystream-node \
        --chain $HOME/joystream/joy-mainnet.json \
        --pruning archive \
        --validator \
        --name "YOUR_NODE_NAME"
Restart=on-failure
RestartSec=3
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target

EOF
```
                                                        
## 6. Start synchronization
```
sudo systemctl daemon-reload
sudo systemctl start joystream
sudo systemctl enable joystream
sudo journalctl -u joystream -f -n 100
```
You can check your node name in [Joystream Telemetry](https://telemetry.polkadot.io/#list/0x6b5e488e0fa8f9821110d5c13f4c468abcd43ce5e297e62b34c53c3346465956)

## 7 . Your Session keys
This keys should be inserted in your validator node through [polkadot.js.org](https://polkadot.js.org/)
```
curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9933
```

## 8. Delete your node

```
sudo systemctl stop joystream
```
```
sudo systemctl disable joystream
sudo rm -rf /etc/systemd/system/joystream.service
sudo rm -rf joystream
sudo rm -rf .local
```

#
👉[Webtropia](https://bit.ly/45KaUj4) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[WebSite](https://www.joystream.org/)

👉[Official guide](https://github.com/Joystream/joystream/tree/master/bin/node)

👉[Joystream Telemetry](https://telemetry.polkadot.io/#list/0x6b5e488e0fa8f9821110d5c13f4c468abcd43ce5e297e62b34c53c3346465956)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
