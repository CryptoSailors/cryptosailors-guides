<p align="center">
 <img src="https://miro.medium.com/max/1400/0*CLWDhlKuw0l2N5bZ.png"width="900"/></a>
</p>

# 1. Requirements

#### Officials:
2vCPU/8 GBRAM/50 GBSSD

#### Running the server on:
2vCPU/8 GBRAM/80 GBSSD

I recommend [Hetzner.](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

I recommend [MobaXTerm](https://mobaxterm.mobatek.net/download.html) for SSH terminal.

# 2. Server Preparation
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cargo cmake -y
```
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
In the process, press "y" and press "1".
```
source "$HOME/.cargo/env"
```
# 3. Node Installation
```
mkdir .sui
```
```
git clone https://github.com/MystenLabs/sui.git
```
```
cd sui
```
```
git remote add upstream https://github.com/MystenLabs/sui
```
```
git fetch upstream
```
```
git checkout -B devnet --track upstream/devnet
```
```
cp crates/sui-config/data/fullnode-template.yaml fullnode.yaml
```
```
curl -fLJO https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob
```
```
cargo build --release -p sui-node
```
# 4. Let's configure our node.
```
cd
```
```
mv sui/fullnode.yaml .sui
```
```
mv sui/genesis.blob .sui
```
```
nano .sui/fullnode.yaml
```
 Open the file and change the line genesis-file-location: "genesis.blob" on ``genesis-file-location: "/root/.sui/genesis.blob"``

<p align="center">
 <img src="https://miro.medium.com/max/1400/1*fgEIUgnzXYjNL2nfYW6t9g.png"width="900"/></a>
</p>

Save and close with CTRL+X,Y, Enter
```
cp sui/target/release/sui-node /usr/bin
```
#### Create a systmed file. Copy everything below in its entirety
```
tee /etc/systemd/system/suid.service > /dev/null <<EOF
[Unit]
Description=sui
After=network-online.target
[Service]
User=root
ExecStart=/usr/bin/sui-node --config-path /root/.sui/fullnode.yaml
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
```
# 5. Launch our node.
```
sed -i.bak "s/127.0.0.1/0.0.0.0/" /root/.sui/fullnode.yaml
```
```
systemctl daemon-reload
systemctl enable suid
systemctl start suid
```
```
journalctl -u suid -f
```
# 6. Checking our node.
In order to check our node, we need to go to https://node.sui.zvalid.com/ and enter our IP address

<p align="center">
 <img src="https://miro.medium.com/max/1400/1*jEeSlmfFrJGYzx1yQ-vB1w.png"width="900"/></a>
</p>

If you have the same as in the picture below, all is well and your node is working.

<p align="center">
 <img src="https://miro.medium.com/max/1400/1*9xsIJzhl2nLTCS66F_IkTw.png"width="900"/></a>
</p>

# 7. Update (if an update came out, then...)
```
systemctl stop suid
```
```
rm -rf /suidb
rm -rf /root/sui/suidb/
rm -rf /root/.sui/genesis.blob
```
```
wget -O /root/.sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob
```
```
cd sui
```
```
git fetch upstream
```
```
git stash
```
```
git checkout -B devnet --track upstream/devnet
```
```
cargo build --release -p sui-node
```
```
cp target/release/sui-node /usr/bin
```
```
systemctl restart suid
```
```
journalctl -u suid -f
```

# 8. Useful commands.
#### View version
```
curl -s -X POST http://127.0.0.1:9000/ -H 'Content-Type: application/json' -d '{ "jsonrpc":"2.0", "method":"rpc.discover","id":1}' | jq .result.info
```
or
```
grep 'version =' /root/sui/crates/sui/Cargo.toml -m 1
```
# 9. Deleting a node
```
systemctl stop suid
```
```
rm -rf /suidb
```
```
rm -rf sui
```
```
rm -rf .sui
```
```
rm -rf /etc/systemd/system/suid.service
```
In order to use the wallet, you do not need to connect your node. Just install the extension and make a couple of transactions plus NFT Mint. You can find detailed instructions [here](https://docs.sui.io/devnet/explore/wallet-browser).
#
👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/sui) 

👉[WebSite](https://sui.io/)

👉[Official guide](https://docs.sui.io/build/fullnode)

👉[GitHub](https://github.com/MystenLabs/sui)

👉[Here you can check your node](https://node.sui.zvalid.com/)

👉[Wallet Instructions.](https://docs.sui.io/devnet/explore/wallet-browser)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
