# In this guide, we will describe how to setup the Binance testnet RPC node.

#### System requirements:
- 16 CPU cores
- 64 GB RAM
- 2 TB SSD (Recommended)

## 1. Node Preparation.
```
sudo apt-get install wget jq unzip aria2 lz4 screen -y
```

## 2. Create Binance User and add it to Sudo group.
Create binance account:
```
adduser --gecos "" binance
sudo usermod -aG sudo binance
```

Add the following line to the ".bashrc" to always enter the "home" directory of the user when you enter the shell:
```
echo "cd ~" >> /home/binance/.bashrc
```

## 3. Download the pre-build binaries.
```
su -s /bin/bash binance
mkdir binaries && cd binaries
wget   $(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest |grep browser_ |grep geth_linux |cut -d\" -f4)
mv geth_linux geth
chmod -v u+x geth
```

Check the current version:
```
./geth version
```

You should see something like this:
```
Geth
Version: 1.1.19
Git Commit: 6587671e748805a438c4c617e766ce168a38e5e6
Architecture: amd64
Go Version: go1.19.5
Operating System: linux
GOPATH=
GOROOT=
```

## 4. Download the config files genesis.json and config.toml.
```
mkdir -p $HOME/.bsc/config
cd $HOME/.bsc/config
wget   $(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest |grep browser_ |grep testnet |cut -d\" -f4)
unzip testnet.zip
rm testnet.zip
```

## 5. Perform sync from genesis
```
cd ~
geth --datadir $HOME/.bsc init $HOME/.bsc/config/genesis.json
```

## 6. Enable journalctl to view Binance RPC node logs.
```
sed -i '/Node.LogConfig/s/^/#/' $HOME/.bsc/config/config.toml
sed -i '/FilePath/s/^/#/' $HOME/.bsc/config/config.toml
sed -i '/MaxBytesSize/s/^/#/' $HOME/.bsc/config/config.toml
sed -i '/Level/s/^/#/' $HOME/.bsc/config/config.toml
sed -i '/FileRoot/s/^/#/' $HOME/.bsc/config/config.toml
```

## 7. Change log settings to persistent if not already.
```
sudo sed -i 's/#Storage=auto/Storage=persistent/g' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald
```

## 8. Setup the Sytemd Service.
```
sudo tee /etc/systemd/system/bscgeth.service > /dev/null <<EOF
[Unit]
Description=BSC node
After=online.target

[Service]
Type=simple
User=binance
ExecStart=/home/binance/binaries/geth --config /home/binance/.bsc/config/config.toml --txlookuplimit=0 --syncmode=full --tries-verify-mode=none --pruneancient=true --diffblock=5000 --cache 8000 --rpc.allow-unprotected-txs --datadir /home/binance/.bsc --http --http.vhosts "*" --http.addr 0.0.0.0 --ws --ws.origins '*' --ws.addr 0.0.0.0 --port 31303 --http.port 8645
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```

## 9. Add Service to autostart and run it.
```
sudo systemctl daemon-reload
sudo systemctl enable bscgeth
sudo systemctl start bscgeth
```
Verify that the service is running and works fine:
```
sudo systemctl status bscgeth
journalctl -u bscgeth -f -n 100 -o cat
```
You should see something like this:
```
INFO [02-25|11:11:38.289] Imported new chain segment               blocks=65 txs=7 mgas=1.510 elapsed=64.653ms mgasps=23.355 number=65 hash=fbcdb0..b98988 age=2y8mo1d  dirty=0.00B
INFO [02-25|11:11:38.837] Imported new chain segment               blocks=319 txs=33 mgas=3.111 elapsed=347.327ms mgasps=8.956  number=384 hash=07fa21..986b45 age=2y8mo1d  dirty=0.00B
INFO [02-25|11:11:39.050] Imported new chain segment               blocks=181 txs=0  mgas=0.000 elapsed=190.440ms mgasps=0.000  number=565 hash=7d341a..b5a407 age=2y8mo1d  dirty=0.00B
INFO [02-25|11:11:41.442] Imported new chain segment               blocks=1908 txs=529 mgas=73.465 elapsed=2.346s    mgasps=31.310 number=2473 hash=085eb4..6805a3 age=2y8mo1d  dirty=0.00B
```

You can run a cURL request to see the status of your node:
```
geth attach http://localhost:8645
eth.syncing
```

If you get something like this in response, your node is setup correctly
```
{
  currentBlock: 24000,
  healedBytecodeBytes: 0,
  healedBytecodes: 0,
  healedTrienodeBytes: 0,
  healedTrienodes: 0,
  healingBytecode: 0,
  healingTrienodes: 0,
  highestBlock: 23846000,
  startingBlock: 0,
  syncedAccountBytes: 0,
  syncedAccounts: 0,
  syncedBytecodeBytes: 0,
  syncedBytecodes: 0,
  syncedStorage: 0,
  syncedStorageBytes: 0
}
```
Wait for it to become false before using it in vald config
```
eth.syncing
false
```

#

👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Moonbeam Official guide](https://docs.moonbeam.network)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our Youtube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
AntonM | C.Sailors#6222 / @antonmashnin
