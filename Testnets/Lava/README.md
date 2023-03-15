<p align="center">
 <img src="https://i.postimg.cc/CxsxpvY3/banner.jpg"/></a>
</p>

# Lava testnet node guide installation.

## 1. Requirements.
#### Official 
- 4 CPU
- 8 GB RAM
- 100 GB SSD
#### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://www.webtropia.com/?kwk=255074042020228216158042)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).
- [Video Tutorial on Russian](https://www.youtube.com/watch?v=KJOEdWPfrvE&t)

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
Make sure that you are installing the [latest release](https://github.com/lavanet/lava/tags). In this guide we use release `v0.7.0`
```
git clone https://github.com/lavanet/lava
cd lava
git checkout v0.7.0 
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
sed -i 's/create_empty_blocks = .*/create_empty_blocks = true/g' ~/.lava/config/config.toml
sed -i 's/create_empty_blocks_interval = ".*s"/create_empty_blocks_interval = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_propose = ".*s"/timeout_propose = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_commit = ".*s"/timeout_commit = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_broadcast_tx_commit = ".*s"/timeout_broadcast_tx_commit = "601s"/g' ~/.lava/config/config.toml
```
#### Setup the latest Snapshot on your node
```
wget http://88.99.33.248:8000/lavadata.tar.gz
```
```
tar -C $HOME/ -zxvf lavadata.tar.gz --strip-components 1
```
```
rm -rf lavadata.tar.gz
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
User=$USER
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

## 7. Create your wallet and claim test tokens.
The comment bellow will give you a wallet address and mnemonic phrase, which you should save on safe place.
```
lavad keys add wallet
```
Ask a test tokens sombody in [Discord](https://discord.gg/BBgprSw2vn). Becouse currently faucet work with issue.
## 8. Сreate own validator
```
lavad tx staking create-validator \
    --amount="10000ulava" \
    --pubkey=$(lavad tendermint show-validator --home "$HOME/.lava/") \
    --moniker="Your_Validator_Name" \
    --chain-id=lava-testnet-1 \
    --commission-rate="0.10" \
    --commission-max-rate="0.20" \
    --commission-max-change-rate="0.01" \
    --min-self-delegation="10000" \
    --gas="auto" \
    --gas-adjustment "1.5" \
    --gas-prices="0.05ulava" \
    --home "$HOME/.lava/" \
    --from=wallet
```
Finaly you should see your validator in [Block Explorer](https://lava.explorers.guru/) on Active or Inactive set.

## 9. Deleting a node
```
sudo systemctl stop lavad
sudo rm -rf .lava
sudo rm -rf lava
sudo rm -rf /go/bin/lavad
sudo rm -rf /etc/systemd/system/lavad.service
sudo rm -rf GHFkqmTzpdNLDd6T
```

## 10. Set up an RPC provider.

To launch an RPC provider, you need to set up your own independent node, which you will later connect to the lava node. Below are examples of connecting some nodes.
Create a new provider wallet with `--keyring-backend`
```
lavad keys add wallet --keyring-backend test
```
Top up your new wallet with lava tokens. You should have at least 50000lava or 50000000000ulava token for successful setup RPC provider.

To ensure your wallet was saved to your keyring, use the following command:
```
lavad keys list --keyring-backend test
```

The excpected value should be:
```
- name: wallet
  type: local
  address: lava@1edbazz2f2svsr7ajlsr54w8a8hypr0u5zcvr3q
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"A+vB423Tgs8I3ZCb34L/5PWCFBN4vfxmAOQss3N3skOP"}'
  mnemonic: ""
```

Please make sure that your wallet contains enough tokens to become a provider. To check the balance you may use the following command:
```
lavad query bank balances "{ACCOUNT_PUBLIC_ADDRESS}" --denom ulava
```

Here is a live example:
```
lavad query bank balances "lava@1edbazz2f2svsr7ajlsr54w8a8hypr0u5zcvr3q" --denom ulava
```

Then we need to stake a single service. For this we need to use the following command:
```
lavad tx pairing stake-provider "{NETWORK_NAME}" \
"{STAKE_AMOUNT}" \
"{SERVICED_NODE_IP}:{SERVICED_NODE_PORT},{PROTOCOL},1" 1 \
--from "{ACCOUNT_NAME}" \
--keyring-backend "{KEYRING_BACKEND}" \
--chain-id "{CHAIN_ID}" \
--gas="auto" \
--gas-adjustment "1.5" \
--node "{LAVA_RPC_NODE}"
```
NETWORK_NAME - The ID of the serviced chain, see the full list here http://public-rpc.lavanet.xyz/rest/lavanet/lava/spec/show_all_chains

STAKE_AMOUNT - The amount you are willing to stake for being a provider for the specific network. Example 2010ulava

SERVICED_NODE_IP - This is the main IP address of our Lava Node server which we need to announce for the Lava Network (for example if the main server IP where we running a provider is 1.1.1.1 we need to set it in this parameter)

SERVICED_NODE_PORT - Port of the node that will service requests (this is a port on which we run our Lava provider in the command provided below)

PROTOCOL - The protocol to be used, see how to query the full list. Example jsonrpc, or rest, in our case we will use "jsonrpc" protocol

ACCOUNT_NAME - The account to be used for the provider staking. Example my_account

KEYRING_BACKEND - A keyring-backend of your choosing, for more information (FAQ: what is a keyring). Example test

CHAIN_ID - The chain_id of the network. Example lava-testnet-1

GEOLOCATION - Indicates the geographical location where the process is located. Example 1 for US or 2 for EU

Here is example of the command:
```
lavad tx pairing stake-provider "ARBN" "64400000002ulava" "1.1.1.1:29658,jsonrpc,2" 2 --from "wallet" --keyring-backend "test" --chain-id "lava-testnet-1" --fees 500ulava --moniker "MyLavaRPCProvider"  -y
```
where:
ARBN - chain name of the Arbitrum Nova Testnet (the full list you can find here: http://public-rpc.lavanet.xyz/rest/lavanet/lava/spec/show_all_chains)
64400000002ulava - number of tokens
1.1.1.1:29658 - IP address of our Lava Network node (where we run our provider and port)
jsonrpc,2 - type of the protocol and geolocation

Finally, we need to run our provider service. For this I would like to recommend creating systemd service:
```
sudo tee /etc/systemd/system/ARBN.service > /dev/null <<EOF
[Unit]
Description=Provider daemon Fantom Mainnet
After=network-online.target


[Service]
ExecStart=$(which lavad) server 1.1.1.1 29658 "http://2.2.2.2:8550" ARBN jsonrpc --from wallet --keyring-backend test --chain-id lava-testnet-1 --geolocation 2
User=lavanetwork
Restart=always
RestartSec=180
LimitNOFILE=infinity
LimitNPROC=infinity

[Install]
WantedBy=multi-user.target"
EOF
```
where:
http://2.2.2.2:8550 - this IP address of our RPC fanton node and ws port of it




#
**🐬Public RPC:** http://88.99.33.248:26657/

**🐬Peer:** `d9703df8c0e5eef6c0766217d611a13ed6ee8d95@88.99.33.248:26656`

**🐬API:** http://88.99.33.248:1317/

**🐬gRPC:** http://88.99.33.248:9090/

**🐬SnapShot:** http://88.99.33.248:8000/lavadata.tar.gz
#
👉[Webtropia](https://www.webtropia.com/?kwk=255074042020228216158042) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/BBgprSw2vn)

👉[WebSite](https://www.lavanet.xyz/)

👉[Official guide](https://docs.lavanet.xyz/)

👉[Lava Explorer](https://lava.explorers.guru/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor

oxes#8647 / @oxess
