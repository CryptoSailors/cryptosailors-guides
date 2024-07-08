<p align="center">
 <img src="https://i.postimg.cc/VvXmPy2M/OHXOz3lib-Ho0j5l-Ovy-XCq.jpg"width="900"/></a>
</p>

# In this guide we will setup Farcaster mainnet node.

#### Flollowing parametrs:
- 4 CPU 
- 16 GB RAM
- 200 GB SSD

## 1. Node Preparation.
```
sudo adduser farcaster
sudo usermod -aG sudo farcaster
sudo su - farcaster
```
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```
```
sudo ufw allow 2283/tcp
sudo ufw allow 2282/tcp
sudo ufw allow 2282/udp
sudo ufw allow 2283/udp
sudo ufw allow 3000/udp
sudo ufw allow 3000/tcp

## 2. Install golang go
Install Golang go according step 2 of [this instruction.](https://github.com/CryptoSailors/cryptosailors-tools/blob/main/Install%20Golang%20%22Go%22/README.md)

## 3. Install docker and docker-compose
Check the latest version of [docker-compose](https://github.com/docker/compose/releases) and follow the guide.
```
sudo apt install docker.io -y
```
```
git clone https://github.com/docker/compose
cd compose
latestTag=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '.tag_name'|cut -d\" -f4)
echo $latestTag
git checkout $latestTag
make 
cd ~
sudo mv compose/bin/build/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo docker-compose version
```
## 4. Install and start Farcaster mainnet node
```
curl -sSL https://download.thehubble.xyz/bootstrap.sh | bash
```

The system will ask following:
- ETH_MAINNET_RPC_URL=your-ETH-mainnet-RPC-URL (you can take from [blastapi.io](https://blastapi.io/))
- OPTIMISM_L2_RPC_URL=your-L2-optimism-RPC-URL (you can take from [blastapi.io](https://blastapi.io/))
- HUB_OPERATOR_FID=your-fid (you can take from [WarpCast](https://warpcast.com/~/invite-page/342012?id=107e8bb7))

# 5. Check your node
Open your browser and insert you link with ip
```http://123.123.123.123:3000```

or you can check it through the linux by comand

```
docker logs hubble-hubble-1 -f --tail 100
```

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Farcaster Official docs](https://docs.farcaster.xyz/hubble/hubble)

👉[Farcaster Github](https://github.com/farcasterxyz/protocol)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)
