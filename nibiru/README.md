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
- 100 GB SSD

## 2. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
```
wget https://golang.org/dl/go1.19.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.2.linux-amd64.tar.gz
```
```
cat <<EOF >> ~/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source ~/.profile
go version
rm -rf go1.19.2.linux-amd64.tar.gz
```
## 3. Node installation.
```
git clone https://github.com/NibiruChain/nibiru
```
```
cd nibiru
```
```
git checkout v0.15.0
```
```
make install
```
```
mv /root/go/bin/nibid /usr/bin/
```
```
chmod +x /usr/bin/nibid
```
```
nibid version
```
You should see version v0.15.0

## 4.Create a wallet
Change `<moniker-name>` on your name
```
nibid init <moniker-name> --chain-id=nibiru-testnet-1 --home $HOME/.nibid
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
curl -s https://rpc.testnet-1.nibiru.fi/genesis | jq -r .result.genesis > genesis.json
```
```
mv genesis.json $HOME/.nibid/config/genesis.json
```

## 5. Updating config.toml file with new peers
```
cd ~
nano .nibid/config/config.toml
```
Scroll down and look for the `persistent_peers line` and add peers to it.
```
persistent_peers = "37713248f21c37a2f022fbbb7228f02862224190@35.243.130.198:26656,ff59bff2d8b8fb6114191af7063e92a9dd637bd9@35.185.114.96:26656,cb431d789fe4c3f94873b0769cb4fce5143daf97@35.227.113.63:26656"
```

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*OLUMjnZaM0IAISO4dMAbGw.png"width="600"/></a>
</p>

Press `CTRL+X,Y,Enter` to exit from nano.

## 6. Download addressbook

```
rm -rf .nibid/config/addrbook.json
```
```
wget https://github.com/CryptoSailors/node-guides/releases/download/Nibiru/addrbook.json
```
```
mv addrbook.json .nibid/config/
```

## 7. Set the necessary values
```
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025unibi"/g' $HOME/.nibid/config/app.toml
```
```
CONFIG_TOML="$HOME/.nibid/config/config.toml"
 sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $CONFIG_TOML
 sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $CONFIG_TOML
```

## 8. Create a service file and start the node
```
tee /etc/systemd/system/nibidd.service > /dev/null <<EOF
[Unit]
Description=Nibid
After=network-online.target
[Service]
User=root
ExecStart=/usr/bin/nibid start
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
```
Start a node
```
systemctl daemon-reload
systemctl start nibidd
systemctl enable nibidd
```
Check logs
```
journalctl -u nibidd -f -n 100
```
Press `CTRL+X,Y,Enter` to exit from the logs

## 9. Requesting tokens from the faucet

While the node is synchronizing, we can request tokens from the faucet. To do this, we need our new generated wallet.
```
nibid keys list
```
Go to [Discord](https://discord.com/invite/BVCw2cYmhu) and request tokens through Faucet

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*N4rbaV9__zJhJJKonQygnw.png"width="600"/></a>
</p>

## 10. Creating a Validator

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
--chain-id nibiru-testnet-1 \
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
nibid tx staking delegate <VAL_ADDRESS> 8000000unibi --chain-id nibiru-testnet-1 --from wallet --gas-prices 0.025unibi
```
## 11 Backup your node

After successfully creating a validator, you must take care of `priv_validator_key.json`. Without it you will not be able to restore the validator. It can be found in the folder `.nibid/config`

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*QO2j4zovK9ZP2jqAccs2eQ.png"width="600"/></a>
</p>

## 12. Deleting a node

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


























