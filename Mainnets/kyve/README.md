<p align="center">
 <img src="https://i.postimg.cc/0rR2Bttq/photo-2023-03-15-00-17-47.jpg"width="900"/></a>
</p>

# In this Guide we will install a Kyve Mainnet Node

## 1. Requirements.
Official 
- 4 CPU
- 8 GB RAM
- 200 GB SSD
- #### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://www.webtropia.com/?kwk=255074042020228216158042)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake snapd lz4 -y
```
```
CHAIN_ID=kyve-1
export FOLDER=.kyve
sudo echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.bash_profile
sudo echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
Install [GO according this instruction](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22)
## 3. Node installation.
```
git clone https://github.com/KYVENetwork/chain
cd chain
git checkout v1.2.0
make install
cd ~
```
## 4.Create a wallet or recover it
Change `<moniker-name>` on your name
```
kyved init moniker --chain-id=$CHAIN_ID
```
To create a new wallet, do:
```
kyved keys add wallet
```
The command will ask for a password and then give you a mnemonic phrase, which you should save in a safe place.

To recover your wallet, do:
```
kyved keys add wallet --recover
```
Download the genis.json file.
```
curl https://files.kyve.network/mainnet/genesis.json > ~/.kyve/config/genesis.json
```
## 5. Configure our node
```
PEERS=b950b6b08f7a6d5c3e068fcd263802b336ffe047@18.198.182.214:26656,25da6253fc8740893277630461eb34c2e4daf545@3.76.244.30:26656
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/$FOLDER/config/config.toml
sed -i 's/indexer =.*/indexer = "null"/g' $HOME/$FOLDER/config/app.toml

```
Create a systemd file for kyve.
```
sudo tee /etc/systemd/system/kyved.service > /dev/null <<EOF

[Unit]
Description=Kyve
After=network-online.target

[Service]
User=$USER
ExecStart=$(which kyved) start
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]

WantedBy=multi-user.target
EOF
```
## 6. This step is optional needed only, if you run more than one node on your machine.
```
COSMOS_PORT=16
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/.kyve/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/.kyve/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/.kyve/config/client.toml
```
## 7. Setup a snapshot
Setup a snashot from [ITRocket Service](https://itrocket.net/services/testnet/kyve/)
```
cp $HOME/.kyve/data/priv_validator_state.json $HOME/.kyve/priv_validator_state.json.backup
```
```
rm -rf $HOME/.kyve/data 
```
```
curl https://files.itrocket.net/testnet/kyve/snap_kyve.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.kyve
```
```
mv $HOME/.kyve/priv_validator_state.json.backup $HOME/.kyve/data/priv_validator_state.json
```

## 8. Start a node
```
sudo systemctl daemon-reload
sudo systemctl start kyved
sudo systemctl enable kyved
sudo journalctl -u kyved -f -n 100
```
We are launchig a node from State Synch. Node need some time to catch up a peers. Press `CTRL+X,Y,Enter` to exit from the logs. To checke your synch launch command:
```
kyved status 2>&1 | jq .SyncInfo
```
If the command gives out `true` - it means that synchronization is still in process
If the command gives `false` - then you are synchronized and you can start creating the validator.

## 9. Creating a Validator
Creating a validator. Change `<YOUR_VALIDATOR_NAME>` on your name
```
kyved tx staking create-validator \
--amount 10000000tkyve \
--commission-max-change-rate "0.1" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(kyved tendermint show-validator) \
--moniker <YOUR_VALIDATOR_NAME> \
--chain-id kaon-1 \
--gas auto \
--from wallet \
--fees 1006000tkyve
```

Check yourself through the [explorer](https://testnet.itrocket.net/kyve).

**Additional commands**
- Your valoper address
```
kyved keys show wallet --bech val
```
- Delegate tokens to the validator
```
kyved tx staking delegate <VAL_ADDRESS> <ammount>tkyve --chain-id kaon-1  --from wallet --gas auto --fees 5000tkyve
```
## 10. Backup your node

After successfully creating a validator, you must take care of `priv_validator_key.json`. Without it you will not be able to restore the validator. It can be found in the folder `.kyve/config`

## 11. Deleting a node

```
sudo systemctl stop kyved
```
```
sudo rm -rf chain
sudo rm -rf /etc/systemd/system/kyved.service
sudo rm -rf go/bin/kyved
sudo rm -rf .kyve
```
#
👉[Dedicated Ryzen 5 Server on webtropia](https://www.webtropia.com/?kwk=255074042020228216158042)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.gg/CpMZu5xhfD) 

👉[WebSite](https://www.kyve.network/)

👉Setup a snashot from [ITRocket Service](https://itrocket.net/services/testnet/kyve/)

👉[Official guide](https://github.com/itrocket-team/testnet_guides/tree/main/kyve)

👉[ITRocket Explorer](https://testnet.itrocket.net/kyve)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

🔰[Our YouTube](https://www.youtube.com/@CryptoSailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor
