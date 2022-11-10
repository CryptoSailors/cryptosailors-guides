<p align="center">
 <img src="https://miro.medium.com/max/4800/0*CiyLJuGubmesKQdT.jpg"width="900"/></a>
</p>

# In this Guide we will install a Gitopia Node

There are no rewards for the testnet, but I recommend reading [this post](https://blog.gitopia.com/post/2022/04/game-of-lore/). 

## 1. Requirements.
Official 
- 4 CPU
- 16 GB RAM
- 1000 GB SSD
- I recommend hosting [netcup.eu](https://www.netcup.eu/bestellen/produkt.php?produkt=2902)- with coupon new users will get discount of 5 EU - 36nc16679836760
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
```
wget https://golang.org/dl/go1.19.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz
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
rm -rf go1.19.3.linux-amd64.tar.gz
```
## 3. Node installation.
```
curl https://get.gitopia.com | bash
```
```
git clone -b v1.2.0 gitopia://gitopia/gitopia
```
```
cd gitopia && make install
```
```
gitopiad version
```
You should get version v0.1.2
## 4.Setting up our node
```
cd ~
```
Chanhe `YOUR_NAME` on your name
```
GITOPIA_MONIKER=YOUR_NAME
```
```
GITPOIA_CHAIN_ID=gitopia-janus-testnet-2
```
```
gitopiad init --chain-id "$GITOPIA_CHAIN_ID" "$GITOPIA_MONIKER"
```
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001utlore\"/" ~/.gitopia/config/app.toml
```
```
sed -i.bak -e "s/^indexer *=.*/indexer = \"null\"/" ~/.gitopia/config/config.toml
```
```
sed -i 's#seeds = ""#seeds = "399d4e19186577b04c23296c4f7ecc53e61080cb@seed.gitopia.com:26656"#' $HOME/.gitopia/config/config.toml
```
```
wget https://server.gitopia.com/raw/gitopia/testnets/master/gitopia-janus-testnet-2/genesis.json.gz
```
```
gunzip genesis.json.gz
```
```
mv genesis.json $HOME/.gitopia/config/genesis.json
```
```
mv go/bin/gitopiad /usr/bin/
```
```
shasum -a 256 $HOME/.gitopia/config/genesis.json
```
You should see outpus `038a81d821f3d8f99e782cbfed609e4853d24843c48a1469287528e632a26162`

## 5. Launch a node
```
tee /etc/systemd/system/gitopiad.service > /dev/null <<EOF
[Unit]
Description=Gitopia
After=network-online.target
[Service]
User=root
ExecStart=$(which gitopiad) start
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
```
```
systemctl start gitopiad
systemctl enable gitopiad
journalctl -u gitopiad -f -n 100
```

## 6. Create a wallet
To start, wait for a full synchronization. To make sure that your node is synchronizated, run the command below.
- If the command gives out `true` - it means that synchronization is still in process.
- If the command gives `false` - then you are synchronized and you can start creating wallet and validator.
```
gitopiad status 2>&1 | jq .SyncInfo
```
<p align="center">
 <img src="https://miro.medium.com/max/4800/1*BTvcKWTbf3MH7vFfB9Xrhg.png"width="600"/></a>
</p>

Now create a wallet. You will get mnemonic phrase which you should save in safe place.
```
gitopiad keys add wallet
```
Now insert the mnemonic you saved into the [Keplr](https://www.keplr.app/) wallet and then go to the [gitopia website](https://gitopia.com/home), connect Keplr with new address and request test tokens.

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*pyCdbBaweXGk7XTmSaMEKQ.png"width="600"/></a>
</p>

## 8. Create a validator
```
gitopiad tx staking create-validator \
--amount="5000000utlore" \
--pubkey=$(gitopiad tendermint show-validator) \
--moniker="<ВАШЕ_ИМЯ_ВАЛИДАТОРА>" \
--chain-id="$GITOPIA_CHAIN_ID" \
--from="wallet" \
--commission-rate="0.1" \
--commission-max-rate=0.15 \
--commission-max-change-rate=0.1 \
--min-self-delegation=1 \
--gas-prices="0.001utlore" \
-y
```
Check you validator through the [explorer](https://explorer.gitopia.com/)

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






