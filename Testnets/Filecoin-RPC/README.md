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
The Curent version don't support go version `v1.20` and latest. We will use `v1.19.7`
```
wget https://golang.org/dl/go1.19.7.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.7.linux-amd64.tar.gz
cat <<EOF >> ~/.bash_profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source ~/.bash_profile
go version
rm -rf go1.19.7.linux-amd64.tar.gz
```
## 3. Install and Start FileCoin testnet node
```
git clone https://github.com/filecoin-project/lotus.git
cd lotus/
export RUSTFLAGS="-C target-cpu=native -g"
export FFI_BUILD_FROM_SOURCE=1
git checkout v1.20.3-hyperspace-nv21-rpc-p01
make clean hyperspacenet
```
## 4. Download the latest snapshot
```
aria2c -x5 https://snapshots.hyperspace.yoga/hyperspace-latest-pruned.car
chmod -Rv 777 hyperspace-latest-pruned.car
```
```
lotus daemon --import-snapshot $HOME/lotus/hyperspace-latest-pruned.car --halt-after-import
```

## 5. Configure your node 
```
sudo nano ~/.lotus/config.toml
```
- Set `ListenAddress`
```
[API]
  # Binding address for the Lotus API
  #
  # type: string
  # env var: LOTUS_API_LISTENADDRESS
   ListenAddress = "/ip4/0.0.0.0/tcp/1234/http"
```
- Set `ListenAddresses` and `AnnounceAddresses`. Take any port wich you wish. In my case port `1235`
```
[Libp2p]
  # Binding address for the libp2p host - 0 means random port.
  # Format: multiaddress; see https://multiformats.io/multiaddr/
  #
  # type: []string
  # env var: LOTUS_LIBP2P_LISTENADDRESSES
  ListenAddresses = ["/ip4/0.0.0.0/tcp/1235"]

  # Addresses to explicitally announce to other peers. If not specified,
  # all interface addresses are announced
  # Format: multiaddress
  #
  # type: []string
  # env var: LOTUS_LIBP2P_ANNOUNCEADDRESSES
  AnnounceAddresses = ["/ip4/0.0.0.0/tcp/1235"]
```
- Set `SplitStore = true` feature to reduce disk usage
- ColdStoreType needs to be set to messages to allow querying FEVM transactions.
```
[Chainstore]
  # type: bool
  # env var: LOTUS_CHAINSTORE_ENABLESPLITSTORE
  EnableSplitstore = true
 
[Chainstore.Splitstore]
  # ColdStoreType specifies the type of the coldstore.
  # It can be "messages" (default) to store only messages, "universal" to store all chain state or "discard" for discarding cold blocks.
  #
  # type: string
  # env var: LOTUS_CHAINSTORE_SPLITSTORE_COLDSTORETYPE
  ColdStoreType = "messages"
```
- Set `EnableEthRPC = true`
```
[Fevm]
  # EnableEthRPC enables eth_ rpc, and enables storing a mapping of eth transaction hashes to filecoin message Cids.
  # This will also enable the RealTimeFilterAPI and HistoricFilterAPI by default, but they can be disabled by config options above.
  #
  # type: bool
  # env var: LOTUS_FEVM_ENABLEETHRPC
  EnableEthRPC = true
```
Save and close file `CTRL+X,Y,NETER`
## 6. Create a systemd service
```
sudo make install-daemon-service
```
```
sudo nano /etc/systemd/system/lotus-daemon.service
```
In the generated systemd file `/etc/systemd/system/lotus-daemon.service`, under `[Service]`,  add and set the `LOTUS_PATH` env variable to the config folder (e.g. `/home/ubuntu/.lotus`).
```
[Service]
Environment=LOTUS_PATH="/path/to/.lotus"
```
Save and close file `CTRL+X,Y,NETER`
## 7. Launch your node
```
sudo systemctl daemon-reload
sudo systemctl enable lotus-daemon
sudo systemctl start lotus-daemon
```
Check your logs 
```
tail -F /var/log/lotus/daemon.log
```

## 8. Your RPC url
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
