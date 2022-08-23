<p align="center">
 <img src="https://miro.medium.com/max/1400/0*o-6sCYLio3KI6vzm.png"width="900"/></a>
</p>

In this guide, I will describe the installation of the node and try to get into the Third Phase of the testnet, where only 225 participants will be selected. The deadlines are as follows:

- Until August of 25 you need to put a node and register it.
- The results will be available at August 29 of August.
- Testnet will start on 30 of August.
- End of testnet will be at 9 of September

# 1. requirements.

#### Official:
- 8 cpu - 16 vCPU.
- 32 GB RAM
#### My recommendation: 
- Ubuntu 20.04 required (You will encounter bugs on 22.04)
- I recommend [Hetzner Dedicated Server AX51-NVME.](https://hetzner.cloud/?ref=NY9VHC3PPsL0)
- I recommend [MobaXTerm](https://mobaxterm.mobatek.net/download.html) for SSH terminal.
# 2. Preparing for installation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cargo cmake -y
```
```
sudo apt install docker.io -y
```
```
git clone https://github.com/docker/compose
```
```
cd compose
git checkout v2.9.0
make
cd
```
```
mv compose/bin/docker-compose /usr/bin
docker-compose version
```
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
First it asks for "y" and then you have to press 1.
```
source "$HOME/.cargo/env"
```
On the next step don't forget change `YOUR_USERNAME` on your name.
```
cat <<EOF >> ~/.bash_profile
export WORKSPACE=testnet
export USERNAME=YOUR_USERNAME
EOF
```
```
source ~/.bash_profile
```
```
mkdir ~/$WORKSPACE
```
# 3. Node installation.
```
wget https://github.com/aptos-labs/aptos-core/releases/download/aptos-cli-v0.3.1/aptos-cli-0.3.1-Ubuntu-x86_64.zip
```
```
unzip aptos-cli-0.3.1-Ubuntu-x86_64.zip
```
```
mv aptos /usr/bin
chmod +x /usr/bin/aptos
rm -rf aptos-cli-0.3.1-Ubuntu-x86_64.zip
cd ~/$WORKSPACE
```
```
wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/docker-compose.yaml
wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/validator.yaml
```
```
aptos genesis generate-keys --output-dir ~/$WORKSPACE/keys
```
# 4. Configuration of our node.
Copy all together. Don't forget to change the `IP_ADRESS` on your IP
```
aptos genesis set-validator-configuration \
    --local-repository-dir ~/$WORKSPACE \
    --username $USERNAME \
    --owner-public-identity-file ~/$WORKSPACE/keys/public-keys.yaml \
    --validator-host IP_ADRESS:6180 \
    --stake-amount 100000000000000
```
# 5. Let's crate layout.yaml
```
sudo tee layout.yaml > /dev/null <<EOF
```
```
root_key: "D04470F43AB6AEAA4EB616B72128881EEF77346F2075FFE68E14BA7DEBD8095E"
users:
    - $USERNAME
chain_id: 43
allow_new_validators: false
epoch_duration_secs: 7200
is_test: true
min_stake: 100000000000000
min_voting_threshold: 100000000000000
max_stake: 100000000000000000
recurring_lockup_duration_secs: 86400
required_proposer_stake: 100000000000000
rewards_apy_percentage: 10
voting_duration_secs: 43200
voting_power_increase_limit: 20
EOF
```
# 6. Launch our node.
```
cd ~/$WORKSPACE
```
```
wget https://github.com/aptos-labs/aptos-core/releases/download/aptos-framework-v0.3.0/framework.mrb -P ~/$WORKSPACE
```
```
aptos genesis generate-genesis --local-repository-dir ~/$WORKSPACE --output-dir ~/$WORKSPACE
```
```
docker-compose up -d
```
If you would like to check your logs, you should run a command inside the folder `cd ~/$WORKSPACE`.
```
docker-compose logs -f
```
Press `CTRL+C` to exit from the logs.

At this point we have finished installing the node. To check your node, go to https://node.aptos.zvalid.com/ . If your output is similar to the picture bellow, you are fine and the node is running.
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*nNm2IkUyarY0vnsgJDWxqw.png"width="900"/></a>
</p>

# 7. Backup your keys
In order to backup your keys, you need to go to the testnet folder and download the keys and the folder with your name to a safe place.
<p align="center">
 <img src="https://miro.medium.com/max/922/1*v1mvCASBn83OEG3yC-bJwQ.png"width="600"/></a>
</p>

# 8. Connecting to the Aptos website
The first thing we have to do is get into their [Discord](https://discord.com/invite/tuDs9TmWwv), then connect to the [website](https://aptoslabs.com/incentivized-testnet) and log in through Discord.
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*1oABZrg9e3SV_Lwz4SYQ0g.png"width="900"/></a>
</p>

# 9. Installing the wallet.
Wallet can only be installed on Google Chrome. Other browsers, unfortunately, the wallet does not support at the time of writing. In order to install the wallet go to their [instructions](https://aptos.dev/guides/install-petra-wallet-extension).

Download the [zip.file](https://github.com/aptos-labs/aptos-core/releases?q=wallet&expanded=true) to your computer and unzip it.
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*_MY-L97Kv-8TiyZtj4vrlg.png"width="900"/></a>
</p>
Open Chrome and go to "Puzzle", then switch to developer mode and add the unpacked file to our browser.
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*_UVxT74zIRCAYo86ca5FLA.png"width="900"/></a>
</p>
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*H3arQX1nAJ0UQzAFDch42g.png"width="900"/></a>
</p>
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*Sud3aOSM-uqtR6jjJgHw0w.png"width="900"/></a>
</p>
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*IW9nA4kXkek5piQifuSvcA.png"width="900"/></a>
</p>
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*Lu2J4Zd_uZuqTU4aPTEnGg.png"width="900"/></a>
</p>
Go to our wallet and create an account. Along the way we save all our mnemonic phrases.
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*6OH1gyywHMdCUWEV0Veoyg.png"width="900"/></a>
</p>

# 10. Fill out the form.
Just follow the pictures
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*L8b2MN_3uk3SqhMYjYJEVg.png"width="900"/></a>
</p>
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*uE6Cw9_FNDmSk4vFw1sxeg.png"width="900"/></a>
</p>
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*m8Cjvp0uahJqUAHHygVjPA.png"width="900"/></a>
</p>
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*Xfuju3rs8DPrgD6E35WXWw.png"width="900"/></a>
</p>

In the item `Node Registration` in the `Owner Key` tab you should automatically get the Public Key. However, it is better to check it with the one in the wallet. Then you can open the file `public-keys.yaml`, downloaded from [annex 7 of this guide](https://github.com/CryptoSailors/node-guides/new/main#7-backup-your-keys), and write out everything you have there. Or, you can type a command in the terminal.
```
cd ~
cat testnet/keys/public-keys.yaml
```
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*rPqlV5MO0E1ikoc7rrGjAA.png"width="900"/></a>
</p>
Below you need to specify your IP and port 80. Then click on Validate Your Node.
<p align="center">
 <img src="https://miro.medium.com/max/1400/1*e0c2vxs8z4qqvDOVP_CgCg.png"width="600"/></a>
</p>
Then click on Validate Your Node and after about two minutes should get something like what I have below.
<p align="center">
 <img src="https://miro.medium.com/max/1006/1*v9hYomHfAoD4eOoOC5cB7A.png"width="600"/></a>
</p>

#

👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.com/invite/tuDs9TmWwv) 

👉[WebSite](https://aptoslabs.com/)

👉[Official guide](https://aptos.dev/nodes/validator-node/run-validator-node-using-docker)

👉[GitHub](https://github.com/aptos-labs/aptos-core/)

👉[Here you can check your node](https://node.aptos.zvalid.com/)

👉[Form on Incentive Testnet](https://aptoslabs.com/incentivized-testnet)

👉[Wallet Instructions.](https://aptos.dev/guides/install-petra-wallet-extension/)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor














































