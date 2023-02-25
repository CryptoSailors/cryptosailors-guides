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
GOPATH=/home/binance/go
GOROOT=/usr/local/go
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
INFO [02-25|11:06:12.190] Imported new chain segment               blocks=2048 txs=3714 mgas=74.357 elapsed=3.847s    mgasps=19.325 number=80818 hash=bac7ca..1f8a16 age=2y7mo4w dirty=0.00B
INFO [02-25|11:06:13.736] Imported new chain segment               blocks=2048 txs=304  mgas=6.385  elapsed=1.529s    mgasps=4.174  number=82866 hash=e103c2..a19ad2 age=2y7mo4w dirty=0.00B
INFO [02-25|11:06:16.672] Imported new chain segment               blocks=2048 txs=310  mgas=6.496  elapsed=2.916s    mgasps=2.228  number=84914 hash=70caf7..77efc9 age=2y7mo4w dirty=0.00B
INFO [02-25|11:06:18.457] Imported new chain segment               blocks=2048 txs=438  mgas=8.994  elapsed=1.771s    mgasps=5.077  number=86962 hash=98386a..11872b age=2y7mo4w dirty=0.00B
INFO [02-25|11:06:20.297] Imported new chain segment               blocks=2048 txs=304  mgas=6.385  elapsed=1.818s    mgasps=3.512  number=89010 hash=44923f..ef1a72 age=2y7mo4w dirty=0.00B
INFO [02-25|11:06:22.123] Imported new chain segment               blocks=2048 txs=304  mgas=6.385  elapsed=1.807s    mgasps=3.531  number=91058 hash=eab3c3..2b6c51 age=2y7mo3w dirty=0.00B
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
                                                           
