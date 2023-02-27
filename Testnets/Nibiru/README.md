<p align="center">
 <img src="https://miro.medium.com/proxy/1*B_PuVSPbQ5E9PaxV7TRcWA.jpeg"width="900"/></a>
</p>

# In this Guide we will install a Nibiru Node

This testnet is currently without awards, but the Incentive Testnet phase is planned for the third phase. There is no information about awards yet. At the moment you can get into the first phase of the testnet.

<p align="center">
 <img src="https://miro.medium.com/max/720/0*heqm_EdLLtJ7nDU1.png"width="600"/></a>
</p>

## 1. Requirements.
Official 
- 2 CPU
- 4 GB RAM
- 400 GB SSD

## 2. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake snapd lz4 -y
```
Install [GO according this instruction](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22)
## 3. Node installation.
```
git clone https://github.com/NibiruChain/nibiru
cd nibiru
git checkout v0.19.2
make install
nibid version
```
You should see version v0.19.2

## 4.Create a wallet
Change `<moniker-name>` on your name
```
nibid init <moniker-name> --chain-id=nibiru-itn-1
```
```
nibid keys add wallet
```
The command will ask for a password and then give you a mnemonic phrase, which you should save in a safe place.

<p align="center">
 <img src="https://miro.medium.com/proxy/1*4Ym6WCEJJXy6cLO9_y41lA.png"width="600"/></a>
</p>

#### Download the genis.json file
```
NETWORK=nibiru-itn-1
curl -s https://networks.itn.nibiru.fi/$NETWORK/genesis > $HOME/.nibid/config/genesis.json
shasum -a 256 $HOME/.nibid/config/genesis.json
```
You should see output `e162ace87f5cbc624aa2a4882006312ef8762a8a549cf4a22ae35bba12482c72`
## 5. Configure our node
```
NETWORK=nibiru-itn-1
sed -i 's|seeds =.*|seeds = "'$(curl -s https://networks.itn.nibiru.fi/$NETWORK/seeds)'"|g' $HOME/.nibid/config/config.toml
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025unibi"/g' $HOME/.nibid/config/app.toml
sed -i 's|enable =.*|enable = true|g' $HOME/.nibid/config/config.toml
sed -i 's|rpc_servers =.*|rpc_servers = "'$(curl -s https://networks.itn.nibiru.fi/$NETWORK/rpc_servers)'"|g' $HOME/.nibid/config/config.toml
sed -i 's|trust_height =.*|trust_height = "'$(curl -s https://networks.itn.nibiru.fi/$NETWORK/trust_height)'"|g' $HOME/.nibid/config/config.toml
sed -i 's|trust_hash =.*|trust_hash = "'$(curl -s https://networks.itn.nibiru.fi/$NETWORK/trust_hash)'"|g' $HOME/.nibid/config/config.toml
```
Create a systemd file for nibiru
```
sudo tee /etc/systemd/system/nibidd.service > /dev/null <<EOF
[Unit]
Description=Nibid
After=network-online.target
[Service]
User=$USER
ExecStart=$(which nibid) start
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
```
## 6. This step is optional needed only, if you run more than one node on your machine.
```
COSMOS_PORT=11
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.profile
source $HOME/.profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/.nibid/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/.nibid/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/.nibid/config/client.toml
```
## 7. Start a node
```
sudo systemctl daemon-reload
sudo systemctl start nibidd
sudo systemctl enable nibidd
sudo journalctl -u nibidd -f -n 100
```
We are launchig a node from State Synch. Node need some time to catch up a peers. 
Press `CTRL+X,Y,Enter` to exit from the logs

## 8. Requesting tokens from the faucet

While the node is synchronizing, we can request tokens from the faucet. To do this, we need our new generated wallet.
```
nibid keys list
```
Go to [Discord](https://discord.com/invite/BVCw2cYmhu) and request tokens through Faucet

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*N4rbaV9__zJhJJKonQygnw.png"width="600"/></a>
</p>

## 9. Creating a Validator

To start, wait for a full synchronization. To make sure that your node is synchronizated, run the command below.
```
nibid status 2>&1 | jq .SyncInfo
```
If the command gives out `true` - it means that synchronization is still in process
If the command gives `false` - then you are synchronized and you can start creating the validator.

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*MXaRUb-QF7n-DjVWIybDNg.png"width="600"/></a>
</p>

Creating a validator. Change `<YOUR_VALIDATOR_NAME>` on your name
```
nibid tx staking create-validator \
--amount 1000000unibi \
--commission-max-change-rate "0.1" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(nibid tendermint show-validator) \
--moniker <YOUR_VALIDATOR_NAME> \
--chain-id nibiru-testnet-2 \
--gas-prices 0.025unibi \ 
--from wallet
```
Check yourself through the [explorer](https://nibiru.explorers.guru/validators).

Take out your vallopers address and delegate the remaining tokens to your validator.
```
nibid keys show wallet --bech val
```
Change `<VAL_ADDRESS>` on address from command above.
```
nibid tx staking delegate <VAL_ADDRESS> 8000000unibi --chain-id nibiru-testnet-2 --from wallet --gas-prices 0.025unibi
```
## 10 Backup your node

After successfully creating a validator, you must take care of `priv_validator_key.json`. Without it you will not be able to restore the validator. It can be found in the folder `.nibid/config`

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*QO2j4zovK9ZP2jqAccs2eQ.png"width="600"/></a>
</p>

## 11. Deleting a node

```
systemctl stop nibidd
```
```
rm -rf /etc/systemd/system/nibidd.service
rm -rf /usr/bin/nibid
rm -rf nibiru
rm -rf .nibid
```
#
👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.com/invite/BVCw2cYmhu) 

👉[WebSite](https://nibiru.fi/)

👉[Official guide](https://docs.nibiru.fi/)

👉[GitHub](https://github.com/NibiruChain)

👉[Nibiru Explorer](https://nibiru.explorers.guru/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor


























