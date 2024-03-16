<p align="center">
 <img src="https://i.postimg.cc/QCQNc0h1/Centrifuge.jpg"/></a>
</p>

# In this guide we will install a Centrifuge Testnet RPC node.

## 1. Requirements.

#### Official 
- 4 CPU or more
- 16 GB RAM
- 500 GB SSD
  
#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
```

## 3. Install a Centrifuge node
```
git clone https://github.com/centrifuge/centrifuge-chain
cd centrifuge-chain
latestTag=$(curl -s https://api.github.com/repos/centrifuge/centrifuge-chain/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
cargo build --release
sudo chmod +x target/release/centrifuge-chain
sudo mkdir data
sudo chmod -R 777 data
cd ~
```

## 4. Create a systemd file
Take care about `--base-path` flag. You should input your `data` folder location. In my case this is `/home/centrifuge/centrifuge-chain/data`
```
sudo tee <<EOF >/dev/null /etc/systemd/system/centrifuge.service
[Unit]
Description="Centrifuge Testnet systemd service"
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=10
User=$USER
SyslogIdentifier=centrifuge_testnet
SyslogFacility=local7
KillSignal=SIGHUP
ExecStart=/home/centrifuge/centrifuge-chain/target/release/centrifuge-chain \
  --name=CryptoSailors🐬 \
  --base-path=/home/centrifuge/centrifuge-chain/data \
  --collator \
  --chain=altair \
  --port 30433 \
  --rpc-port 9934 \
  --rpc-cors=all \
  --parachain-id=2088 \
  --execution=wasm \
  --wasm-execution=compiled \
  --unsafe-rpc-external \
  --rpc-methods=unsafe \
  --pruning=archive \
  --bootnodes=/ip4/35.198.171.148/tcp/30333/ws/p2p/12D3KooWDXDwSdqi8wB1Vjjs5SVpAfk6neadvNTPAik5mQXqV7jF \
  --bootnodes=/ip4/65.108.136.39/tcp/30333/p2p/12D3KooWE5h6gyrwGDpGvVHZPpqRX7G9XyYoyyk3XwNmaQqXYo5D \
  --log=main,info \
  --trie-cache-size 0 \
  --no-private-ipv4 \
  --no-mdns \
  -- \
  --execution=wasm \
  --wasm-execution=compiled \
  --port 30434 \
  --rpc-port 9935 \
  --no-private-ipv4 \
  --no-mdns \
  --sync fast \
  --state-pruning 100 \
  --blocks-pruning 100 \
  --database paritydb \
  --chain=kusama

[Install]
WantedBy=multi-user.target
EOF
```
                                            
## 5. Start synchronization
```
sudo systemctl daemon-reload
sudo systemctl start centrifuge
sudo systemctl enable centrifuge
sudo journalctl -u centrifuge -f -n 100 -o cat
```

- You can check yourself in [Centrifuge Polkadot Telemetry](https://telemetry.polkadot.io/#list/0xb3db41421702df9a7fcac62b53ffeac85f7853cc4e689e0b93aeb3db18c09d82) by your name
- Also you can check your synch by comand bellow:
```
curl -H "Content-Type: application/json" -d '{{"id":1, "jsonrpc":"2.0", "method": "eth_syncing", "params":[]}}' localhost:9934
```
The output `{"jsonrpc":"2.0","result":false,"id":1}` means that you are succesfully synced.

## 6. Deleting a node
```
sudo systemctl stop centrufuge
sudo rm -rf centrifuge-chain
sudo rm -rf /etc/systemd/system/centrufuge.service
```

## 7. Upgrade your node
```
source "$HOME/.cargo/env"
cd centrifuge-chain
git pull
latestTag=$(curl -s https://api.github.com/repos/centrifuge/centrifuge-chain/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
cargo build --release
sudo chmod +x target/release/centrifuge-chain
sudo ./target/release/centrifuge-chain --version
sudo systemctl restart centrifuge
```
Then check your logs
```
sudo journalctl -u centrifuge -f -n 100 -o cat
```

## 8. Your RPC URL
- `http://YOUR_IP_ADDRESS:9934` 

#
👉[Webtropia](https://bit.ly/45KaUj4) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/r5SSnqXyQG)

👉[WebSite](https://centrifuge.io/)

👉[Official Github](https://github.com/centrifuge/centrifuge-chain)

👉[Official guide](https://docs.centrifuge.io/)

👉[Centrifuge Explorer](https://telemetry.polkadot.io/#list/0xaa3876c1dc8a1afcc2e9a685a49ff7704cfd36ad8c90bf2702b9d1b00cc40011)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)
