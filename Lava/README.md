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
sed -i 's|seeds =.*|seeds = "3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"|g' $HOME/.lava/config/config.toml


## 6. Start synchronization

```
sudo systemctl start chainflip-node
sudo systemctl enable chainflip-node
sudo systemctl status chainflip-node
```
```
tail -f /var/log/chainflip-node.log
```
<b>IMPORTANT</b>: wait for full synchronization. Otherwise you screw up all the work. Full synchronization will look like this:

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*hkg-T_Ea5LwZIGVfExG9QQ.webp"width="600"/></a>
</p>

After full synchronization, start the second service.

```
sudo systemctl start chainflip-engine
sudo systemctl enable chainflip-engine
sudo systemctl status chainflip-engine
```
```
tail -f /var/log/chainflip-engine.log
```
You will have Errors in your logs. This is normal. We now need to stake the tokens into our node.
```
sudo nano /etc/logrotate.d/chainflip
```
In the editor, paste everything below
```
/var/log/chainflip-*.log {
  rotate 7
  daily
  dateext
  dateformat -%Y-%m-%d
  missingok
  notifempty
  copytruncate
  nocompress
}
```
To exit the nano editor, press CTRL+X,Y, Enter.
```
sudo chmod 644 /etc/logrotate.d/chainflip
```
```
sudo chown root.root /etc/logrotate.d/chainflip
```

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
