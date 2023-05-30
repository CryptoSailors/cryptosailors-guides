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
Install [GO according this instruction](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22)
## 3. Node installation.
```
git clone https://github.com/KYVENetwork/chain
cd chain
git checkout v1.2.0
make install ENV=kyve-1
cd ~
```
## 4.Create a wallet or recover it
Change `<moniker-name>` on your name
```
kyved init moniker --chain-id=kyve-1
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
curl https://raw.githubusercontent.com/KYVENetwork/networks/main/kaon-1/genesis.json > ~/.kyve/config/genesis.json
```
## 5. Configure our node
```
PEERS="48d9c401d033ac39f33ac3b12ce485dd56679f00@81.30.157.35:14656,664e06d2d6110c5ba93f8ecfee66f150bad981bf@kyve-testnet-peer.itrocket.net:28656,5f54a853e7224ad32cbe4e5cddead24b512b629f@51.159.191.220:28656,5d79eb04b94300f5a7982e065a6340ba4ebd4da3@45.33.28.253:26656,157e0aca4aa382d62e24ffc7f936a5e8bbf4e90e@207.180.245.116:46656,b2b4479a6cb001ffe39d4a95f31bb6993ae0a256@194.163.190.31:26656,c0c8ed45a6c266c4ebe028788456cb14b44164bb@65.109.37.21:27656,f5a6484b239fdbe3f9c9bad889d737e8a9f153c6@149.102.140.248:46656,cf69d30beecfdd44d497fb56eb61b12bbffaf38f@167.86.72.171:26656,39392cf41c1d7ae8f98b6efaa740dc4abe3002ff@65.109.92.241:20656,72df41dabaa13d194e2aa633b1f9af60c9cbd5a2@45.158.38.38:26656,0a7504c77cbeb0c3ead588972780f4c670f5a377@65.109.135.149:26656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.kyve/config/config.toml
sed -i 's/indexer =.*/indexer = "null"/g' $HOME/.kyve/config/app.toml

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
COSMOS_PORT=14
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
