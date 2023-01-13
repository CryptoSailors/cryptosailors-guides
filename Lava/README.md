<p align="center">
 <img src="https://i.postimg.cc/CxsxpvY3/banner.jpg"/></a>
</p>

# In this Guide we will install a Lava testnet node.

## 1. Requirements.
#### Official 
- 4 CPU
- 8 GB RAM
- 100 GB SSD
#### My Recomandation
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://www.webtropia.com/?kwk=255074042020228216158042)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
```
CHAIN_ID=lava-testnet-1
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.profile
source $HOME/.profile
```
## 3. Install golang go
Use [this guide](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22#2-if-you-installing-golang-go-on-clear-server-you-need-input-following-commands) to install golang go using the second section.

## 4. Install a node
Make sure that you are installing the [latest release](https://github.com/lavanet/lava/tags). In this guide we use release `v0.4.3`
```
git clone https://github.com/lavanet/lava
cd lava
git checkout v0.4.3 
make install
```
```
cd ~
```
```
lavad init <your_node_name_here> --chain-id=$CHAIN_ID
```
```
git clone https://github.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T.git
mv GHFkqmTzpdNLDd6T/testnet-1/genesis_json/genesis.json .lava/config
```

## 5. Node Configuration
```
sed -i 's|seeds =.*|seeds = "3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"|g' $HOME/.lava/config/config.toml
```
#### Optional (You can skip this step)
If you run more than one cosmos node, you can change a ports using the comands bellow.
```
COSMOS_PORT=12
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.profile
source $HOME/.profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/.lava/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/.lava/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/.lava/config/client.toml
```

#### Create a systemd file for lava node
```
sudo tee /etc/systemd/system/lavad.service > /dev/null <<EOF
[Unit]
Description=Lava Node
After=network-online.target

[Service]
User=lava
ExecStart=$(which lavad) start
Restart=always
RestartSec=180
LimitNOFILE=infinity
LimitNPROC=infinity

[Install]
WantedBy=multi-user.target
EOF
```
                                                        
## 6. Start synchronization
```
sudo systemctl daemon-reload
sudo systemctl start lavad
sudo systemctl enable lavad
sudo journalctl -u lavad -f -n 100
```
Wait until your node is fully synchronized. To check your synchronization status use command bellow.
```
lavad status 2>&1 | jq .SyncInfo
```
- If node show `false` - that means that you are synched and can contine. 
- If node show `true` - that means that you are **NOT** synched and should wait.
## 7. Claim test tokens, register your own validator and stake tokens.

We add the tFLIP token to Metamask. Contract address `0x8e71CEe1679bceFE1D426C7f23EAdE9d68e62650`

- Go to their [Swap Dex](https://tflip-dex.thunderhead.world/) and change gETH to tFLIP. We need at least 10 tFLIPs to register a node.
- Go to their [application](https://stake-perseverance.chainflip.io/auctions). Connect a wallet with test tokens and go to the My Nodes tab.
- Click on ADD Node. You will open a tab "Register New Node".
- At the "Validator Public Key (SS58)" line  enter your SS58 key, which you have generated in the beginning. At the Stake line, enter the number of tokens you want to stake and click the Stake button. You need to confirm two transactions.

## 8. Registering the validator

Register with the following command
```
sudo chainflip-cli \
      --config-path /etc/chainflip/config/Default.toml \
      register-account-role Validator
```
Activate our validator
```
sudo chainflip-cli \
    --config-path /etc/chainflip/config/Default.toml \
    activate
```
Rotating keys
```
sudo chainflip-cli \
    --config-path /etc/chainflip/config/Default.toml rotate
```
Changing our name. Replace `my-discord-username` with your name.
```
sudo chainflip-cli \
    --config-path /etc/chainflip/config/Default.toml \
    vanity-name my-discord-username
```
## 9. Auction

Chainflip has an auction system. The auction involves selecting validators every epoch (14 days), and those validator nodes that have more tokens go through. So, even if you forage 7k tokens (that's how many tokens you need on November 28 to get into the active set), it doesn't mean that you'll become a validator.

## 10. Deleting a node
```
sudo systemctl stop chainflip-engine
sudo systemctl stop chainflip-node
sudo rm -rf /etc/apt/keyrings 
sudo rm -rf /etc/apt/sources.list.d/chainflip.list
sudo rm -rf /etc/chainflip
sudo rm -rf /etc/logrotate.d/chainflip
```
#
👉[Webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.com/invite/aZr8jbx2zh)

👉[WebSite](https://chainflip.io/)

👉[Official guide](https://docs.chainflip.io/perseverance-validator-documentation/)

👉[Chainflip Explorer](https://blocks-perseverance.chainflip.io/)

👉[Swap Dex](https://tflip-dex.thunderhead.world/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor