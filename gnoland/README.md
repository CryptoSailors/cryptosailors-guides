<p align="center">
 <img src="https://miro.medium.com/max/1400/0*4RQzUdFdff1MQcpR"width="900"/>
</p>

In this article, we will consider how to install a node and perform the first task, which will probably be rewarded.

<i>Well, we’re excited to tell you that there is an ongoing task available on GNO.LAND for anyone to try out. The tricky part is that you have to participate using the CLI. We’ve created this guide for adventurous Gnomes who are willing to challenge themselves to complete the task for <b>potential rewards.</b> </i>
  
# 1. requirements.

#### Official:
- 2 vcpu
- 2 GB RAM
- 40 GB SSSD
#### My recommendation: 
- I recommend [Hetzner Dedicated Server AX51-NVME.](https://hetzner.cloud/?ref=NY9VHC3PPsL0)
- I recommend [MobaXTerm](https://mobaxterm.mobatek.net/download.html) for SSH terminal.
# 2. Preparing for installation.
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen -y
```
```
wget https://golang.org/dl/go1.19.linux-amd64.tar.gz
```
```
sudo tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz
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
rm -rf go1.19.linux-amd64.tar.gz
```
# 3. Node installation.
```
git clone https://github.com/gnolang/gno/
```
```
cd gno
git checkout chain/test3.0
make
```
```
cd ~
```
```
mv gno/build/gnokey /usr/bin
```
```
chmod +x /usr/bin/gnokey
```
Replace `<accaount_name>` on your name. The command will give you mnemonic. Save it to a safe place.
```
gnokey add <accaount_name>
```
(Optional) If you need to restore the wallet, run the following commands.
```
gnokey add <accaount_name> --recover
```
Copy your address that starts with "g1qpyg1qpy5..." and save it somewhere easily accessible.
```
gnokey list
```
# 4. Getting test tokens.

Then we go to this [faucet](https://app.gno.tools/faucet) and requiest test tokens.

In order to check how many tokens you have on your balance, type the command below.Replace `<address>` with your address and delete `<>`
```
gnokey query auth/accounts/<b><address></b> --remote test3.gno.land:36657
```
# 5. Registering our account.
Replace `<address>` with your address. Remove the `<>`.
```
gnokey query auth/accounts/<address> --remote test3.gno.land:36657
```
You should get the output as shown in the image below. From this output you need to write out `account_number` and `sequence`.
<p align="center">
 <img src="https://cdn-images-1.medium.com/max/750/1*gWBf6kylC8vKa-he5XdZqg.png"width="600"/>
</p>

1) Replace `<address>` and `<USERNAME>` with your own values. Remove `<>` 
2) `<USERNAME>` can only contain small letters and must be 6~17 characters.
```
gnokey maketx call <ADDRESS> --pkgpath "gno.land/r/demo/users" --func "Register" --gas-fee 1000000ugnot --gas-wanted 3000000 --send "200000000ugnot" --args "" --args "<USERNAME>" --args "" > unsigned.tx
```
#### Creating a transaction
Replace `<address>` , `<ACCOUNTNUMBER>` and `<SEQUENCENUMBER>` with your values. Delete `<>`

```
gnokey sign <ADDRESS> --txpath unsigned.tx --chainid test3 --number <ACCOUNTNUMBER> --sequence <SEQUENCENUMBER> > signed.tx
```
Conducting a transaction
```
gnokey broadcast signed.tx --remote test3.gno.land:36657
```
Check our username at the [link](https://test3.gno.land/r/demo/users). If it's there, it's done.

<p align="center">
 <img src="https://cdn-images-1.medium.com/max/750/1*LLxVHeTvRT1WNufeSWNVZg.png"width="600"/>
</p>

# 6. Creating a name in BoardName
Replace `<address>` and `<BOARDNAME>` with your values. Delete `<>`
```
gnokey maketx call <address> --pkgpath "gno.land/r/demo/boards" --func "CreateBoard" --gas-fee 1000000ugnot --gas-wanted 10000000 --send 1000000ugnot --broadcast true --chainid test3 --args "<BOARDNAME>" --remote test3.gno.land:36657
```
Follow the [link](https://test3.gno.land/r/demo/boards) and check your name on the board list. It will look like this:

<p align="center">
 <img src="https://cdn-images-1.medium.com/max/750/1*sHbDwaNPzUMZRf-pTuqHYA.png"width="600"/>
</p>

# 7. Adding some information to our board
After you appear in the board, click on your name, and then go to [post]
<p align="center">
 <img src="https://cdn-images-1.medium.com/max/750/1*AgdMbjB25H-Xdf2pKIjNZg.png"width="600"/>
</p>
<p align="center">
 <img src="https://cdn-images-1.medium.com/max/750/1*QOpRZLt50vMi7g4vHtErHg.png"width="600"/>
</p>

Fill in all the necessary information. The command line will generate a command for you to insert into the terminal.

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*1Dv1eCKpCDGjvU_PtJeYBA.webp"width="500"/>
</p>

#

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*ZyLu1jFpZvNxZq9ug2a9Hw.webp"width="600"/>
</p>

The final result should be like this:

<p align="center">
 <img src="https://miro.medium.com/max/4800/1*aJoxXr5adQDVDh7JiZYyag.webp"width="900"/>
</p>

# 9. Deleting a node.
```
rm -rf /usr/bin/gnokey
rm -rf gno
rm -rf .gno
```

#

👉[Hetzner — server rental](https://hetzner.cloud/?ref=NY9VHC3PPsL0)

👉[SSH terminal MobaxTerm](https://mobaxterm.mobatek.net/download.html)

👉[Discord](https://discord.com/invite/tuDs9TmWwv) 

👉[WebSite](https://gno.land/)

👉[GitHub](https://github.com/gnolang/gno)

👉[Gno Faucet](https://test2.gno.land/faucet)

👉[Gno user register](https://test2.gno.land/r/users)

👉[Gno board](https://test3.gno.land/r/demo/boards)

🔰[Our Telegram Channel](https://t.me/CryptoSailorsAnn)

🔰[Our WebSite](cryptosailors.tech)

🔰[Our Twitter](https://twitter.com/Crypto_Sailors)

#### Guide created by 
Pavel-LV | C.Sailors#7698 / @SeaInvestor



































