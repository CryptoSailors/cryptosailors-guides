<p align="center">
 <img src="https://i.postimg.cc/4xV0YcVk/398312834-1264357517679972-6145588202110043290-n.png"/></a>
</p>

# In this Guide we will install a Crossfi Testnet Node

## 1. Requirements.
Official 
- 4 CPU
- 8 GB RAM
- 200 GB SSD
- #### My Recommendations
- I recommend Dedicated Ryzen 5 Server on [webtropia](https://bit.ly/45KaUj4)
- I recommend for convenience the SSH terminal - [MobaXTerm](https://mobaxterm.mobatek.net/download.html).

## 2. Create a user
```
sudo adduser crossfi
sudo usermod -aG sudo crossfi
sudo usermod -aG systemd-journal crossfi
sudo su - crossfi
```

## 3. Server preparation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake snapd lz4 -y
```
```
CHAIN_ID=crossfi-evm-testnet-1
export FOLDER=.mineplex-chain
export MONIKER=YOUR_NODE_NAME_HERE
echo "export MONIKER=${MONIKER}" >> $HOME/.bash_profile
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
Install [GO according this instruction](https://github.com/CryptoSailors/cryptosailors-tools/tree/main/Install%20Golang%20%22Go%22)

## 4. Node installation.
```
wget https://github.com/crossfichain/crossfi-node/releases/download/v0.3.0-prebuild3/crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz && tar -xf crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz
```
```
sudo cp bin/crossfid /usr/bin/
sudo chmod +x /usr/bin/crossfid
git clone https://github.com/crossfichain/testnet.git
```
Change `<moniker-name>` on your name
```
crossfid init <moniker-name> --chain-id=$CHAIN_ID
```

## 5. Configure our node
```
PEERS="66bdf53ec0c2ceeefd9a4c29d7f7926e136f114a@crossfi-testnet-peer.itrocket.net:36656,54d39f9900e89427df4cb78c8b4e0dccc36d8485@65.109.68.69:26656,2ce3b5d3ce236afe1fe1f4024c888ea59febac4a@65.108.206.118:60556,bac7399246b676462f01ce7c675d1db9a500a489@37.27.59.71:26056,3bf54dd549c4fc813fc5a3e88980f7ec5a96e327@135.181.221.161:26656,2e6308d166b358b0b57f5dec6e0b8b57430ed898@65.109.30.35:36656,36cdb99f70ce1b25701ef36e4677283604df7f72@135.181.254.119:26656,d2e91f7beb01e0bade12a7bae7c78bfee0ef7ca4@95.217.199.12:26605,4dbf9662be216b57b33a7c78c98f63593d16a3cd@65.108.127.160:46656,881d2f60fdf355890a367acaca27ad647f7f0b8a@65.108.204.107:26656,07d235c3c733271b637fac55747c47bb25ca35be@95.217.159.127:26056,fe74efeb172b700f462a0d81657288208706565d@37.27.13.51:26656,49329ba22c738e0a8ba172e84e187f0f8409e419@95.216.22.44:16656,fbe54f5ef1ef4d2e1c9541b416efb70f305a60f2@37.27.12.181:26656,087e70916b110025e25626c41a1173166be9f2db@65.21.32.216:60856,15d98d28c80bc2fe02ee5be4a7098d401e4f5aab@37.27.35.234:26656,bf6ae47aa4746811d47d495f3ae1987118541343@65.109.93.152:26806,f1e2e6a9e757b047626898b93f759e150347858e@109.199.119.91:26656,19b35c650a17e5120ae4930506e71d975fb7146c@78.47.143.11:26656,8b66ffd88c967f7903145aed74f792721785a04b@185.250.37.122:11656,e5ea7ec43439b6204bce96d7453644829ad84c6c@167.235.65.75:26656,58b683da6bf0dd0eccbead6b8bd893cb2092895e@109.199.117.195:26656,664072ad3414ad4253c127ed21345349dea64c9a@167.235.17.29:26656,2120a4e8c5b44e6a02adb9a8f6bab549e2a68c47@109.123.254.211:26656,27e1c6c211f0ec0e7ca6907f30c201e7b128d694@138.201.31.235:26656,5a7977896986c3dd90bdf5c0b843326866bba789@78.46.99.50:26656,2b2c2ace720dddcfd8f8c0b5a75b31987c960deb@167.235.34.120:26656,dda09f9625cab3fb655c22ef85d756fc77132b9d@167.235.102.45:10956,03cdf2792e994e15e17d8698346f31de570533af@136.243.104.103:23956,c90c4360be9ff903c4c58f4bb5a1e0322640616a@167.235.12.38:14656,c42d7c18326e3d6b5390093ead3c27c954fcd439@162.55.2.58:26656,1c01627ca85575fac10cd4fad921c8bbe9a5bfcc@188.40.66.226:26656,44518f0fa81b889d1a41d5e4cec3c88a97068d10@94.130.35.35:26656,62adff3a93a838d9fa46fad4015cbb2a00ca36ba@148.251.235.130:19656,b7787910d1ad7eaebaad853aa7d5d3a23bdb0dd7@46.4.108.72:26656,55352556de7f26d85ff8b83bb4d6552a2dac8964@37.60.238.186:36656,2842d2ebc3f0e075bfeccf1088dbc97893527227@84.247.162.198:26656,68f34017444b6feb6c00daf2dcdc72bc277b4136@84.46.249.218:26656,b35ba40c2946403d81a247a79296bc83faa1f473@213.199.34.40:26656,057057e6fa1ecc183b6206ea107f66d8d0728059@109.199.118.172:26656,01d2c34725b52d3d0022afd302ca5f5662d33655@185.177.116.79:26656,69ebbb33feb00364aadd6a7d883f98878d499130@149.102.159.76:15656,19c837c2b60e7af1f0d7654829ac29e11453fccd@118.71.153.202:26056,c8914e513463791d91cc9ab35035c0c1111f307f@84.247.183.225:36656,5ebd3b1590d7383c0bb6696ad364934d7f1c984e@160.202.128.199:56156,b3e04f754675ec53919a26ea990918f8f7bd69e5@144.217.68.182:26056,4975453979deeb048e3f5d4ad07959928f3069b8@51.81.185.180:36656,c7cc70eb412dba92d1d711caea90d40cce98fcfc@84.247.147.202:26656,39ab4ec04d314c27bdfffa045a7b1b58806382ea@15.235.144.20:14656,43a274822ff179a87fa454151ce25a675946f967@103.97.111.75:26656,17a62c1f41936d51fd5b20abced4e20c0873daf0@134.209.103.9:26656,c3ac76d1d2dd72006372fa32805b011d36917bda@5.104.80.240:26656,24f414646750bae4afb1190f80140851dc702b65@159.223.194.26:26056,797642220cbad328576a7311cb5941251b2f921f@103.186.33.87:26656,136c50c29240f5f1cdcd95d9833ac10a3a5a32a7@65.109.34.241:26656,718ec979071a37c598b9ed472e48eded9a84facd@65.108.208.100:26656,16a00c5dc938554e8abdf3ec9a622391154034a6@65.108.60.31:26656,5586cbba4c8c5a810d5cde7a1a9b7355fbd372b4@65.109.239.90:26656,a23681c39c099fd0d12b8ced173ed716909a6220@51.89.21.232:26656,c8333d73f10b6cc83a5a10dfa51a374366ebd56d@5.75.131.173:26656,dcdc305bbbfe131074f686977ac46e1ee4fa472d@45.83.106.100:26656,cee875910e8ce0e500f651079ac160b92162aa66@213.199.35.216:26656,024a84ca565ca91c65b1fb44b805cd715c939f83@185.132.178.23:26656,5301b7903d8bf74a183ff3316bb8645f18950da3@37.120.173.44:11456,eb4a59d6878c6fdd46ce20f23c5b080e2e354bd8@213.199.35.26:26656,546568415dc71e95bc6a6238000aea0a9f51652a@213.199.38.233:26656,89da893aafe2a2b19145fd24d6157259fa7ed932@109.199.119.165:26656,257e7d6a442523a272bd0c81d458aa4d866def0e@173.249.18.23:26656,dfdf777685f8b4ef529c371aa1ed9160a810ddf4@213.199.37.254:26656,565fa7a934c083867e9c11fde1b841fa066479d4@35.240.115.172:26656,bc8b05df95c67f23a6f4a012516866e9fdd0ffd6@173.249.35.20:26656,3169e738b0e6eb10b6abf927320d0ad1969d3274@38.242.134.254:26656,660e9306994e8e6690c0f076be45a4439c78fe0d@198.244.215.141:30656,4b6c13b8820fd6c1bcf5e36c3097a1b64e4e3b8c@152.53.18.245:11656,dbab54976717d96c753539e3d5e26e5c5cde9a2b@144.91.87.50:26656,b172fbd2101002bbc401a623f066ec322e3a4800@45.152.243.26:26656,30022f52a1d9a18b0840e74cd2885d3ce0dea278@148.251.3.125:26656,52ec717e8036498831917f5920af822841fcd9a4@213.199.40.21:26656,1e73da0b04fc067147dac665800f39d439c7c2bf@144.91.126.238:11656,a6bd4324b0247ede4fe8c7521f2e9267cb5b7bd2@81.0.220.178:13656,8b7f44a0e04fe817e089839b8a2e69189f024d5d@37.60.246.80:15656"
SEEDS=""
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$FOLDER/config/config.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/$FOLDER/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/$FOLDER/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/$FOLDER/config/config.toml
sed -i 's|indexer =.*|indexer = "'null'"|g' $HOME/$FOLDER/config/config.toml
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
  $HOME/$FOLDER/config/app.toml
```
Create a systemd file for crossfi.
```
sudo tee /etc/systemd/system/crossfid.service > /dev/null <<EOF

[Unit]
Description=Crossfi
After=network-online.target

[Service]
User=$USER
ExecStart=$(which crossfid) start --chain-id $CHAIN_ID
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]

WantedBy=multi-user.target
EOF
```
```
cp -r testnet/config/genesis.json $HOME/.mineplex-chain/config/
```
## 5. This step is optional needed only, if you run more than one node on your machine.
```
COSMOS_PORT=10
echo "export COSMOS_PORT=${COSMOS_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOS_PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOS_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOS_PORT}546\"%" $HOME/$FOLDER/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${COSMOS_PORT}657\"%" $HOME/$FOLDER/config/client.toml
```

## 6. Download latest Snapshot
We will you snapshot from [Itrocket validator](https://itrocket.net/services/testnet/crossfi/)
```
cp $HOME/$FOLDER/data/priv_validator_state.json $HOME/$FOLDER/priv_validator_state.json.backup
rm -rf $HOME/$FOLDER/data $HOME/$FOLDER/wasmPath
curl https://testnet-files.itrocket.net/crossfi/snap_crossfi.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/$FOLDER
mv $HOME/$FOLDER/priv_validator_state.json.backup $HOME/$FOLDER/data/priv_validator_state.json
```

## 7. Start a node
```
sudo systemctl daemon-reload
sudo systemctl start crossfid
sudo systemctl enable crossfid
sudo journalctl -u crossfid -f -n 100
```
To checke your synch launch command:
```
crossfid status 2>&1 | jq .SyncInfo
```
If the command gives out `true` - it means that synchronization is still in process
If the command gives `false` - then you are synchronized and you can start creating the validator.

## 8. Create your wallet.
The comment bellow will give you a wallet address and mnemonic phrase, which you should save on safe place.
```
crossfid keys add wallet
```
If you would like recover your wallet
```
crossfid keys add wallet --recover
```

## 9. Сreate own validator
```
crossfid tx staking create-validator \
 --amount=999600000000000000mpx \
 --pubkey=$(crossfid tendermint show-validator) \
 --moniker="$MONIKER" \
 --identity "" \
 --website "" \
 --details "" \
 --chain-id=$CHAIN_ID \
 --commission-rate="0.10" \
 --commission-max-rate="0.20" \
 --commission-max-change-rate="0.01" \
 --min-self-delegation="1000000" \
 --gas="auto" \
 --gas-prices="10000000000000mpx" \
 --gas-adjustment=1.5 \
 --from=wallet
```
Finaly you should see your validator in [Block Explorer](https://testnet.itrocket.net/crossfi/uptime) on Active or Inactive set.

## 10. Backup your node
After successfully creating a validator, you must take care of `priv_validator_key.json`. Without it you will not be able to restore the validator. It can be found in the folder `.mineplex-chain/config`

## 11. Deleting a node
```
sudo systemctl stop crossfid && \
sudo systemctl disable crossfid && \
rm /etc/systemd/system/crossfid.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf uptick && \
rm -rf $FOLDER && \
rm -rf $(which crossfid)
```

#
👉[Webtropia](https://bit.ly/45KaUj4) Only Dedicated Server.

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[WebSite](https://crossfi.org/)

👉[Official guide](https://github.com/crossfichain/testnet)

👉[Crossfi Explorer](https://testnet.itrocket.net/crossfi/uptime)

👉[Itrocket snapshot](https://itrocket.net/services/testnet/crossfi/)

👉[Сrossfi Github](https://github.com/crossfichain)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 

seainvestor / @SeaInvestor
