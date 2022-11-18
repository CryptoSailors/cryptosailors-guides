```
git clone https://github.com/ava-labs/avalanchego
cd avalanchego
```
```
mkdir build
cd build
```
```
wget https://github.com/ava-labs/avalanchego/releases/download/v1.9.3/avalanchego-linux-amd64-v1.9.3.tar.gz
tar -xvzf avalanchego-linux-amd64-v1.9.3.tar.gz
```
```
mv avalanchego-v1.9.3 avalanchego-launch
rm -rf avalanchego-linux-amd64-v1.9.3.tar.gz
cd ~ 
```
```
tee /etc/systemd/system/avaxd.service > /dev/null <<EOF

[Unit]
Description=Avalanche
After=network-online.target

[Service]
User=root
ExecStart=/root/avalanchego/build/avalanchego-launch/avalanchego
Restart=always
RestartSec=3
LimitNOFILE=40000
[Install]

WantedBy=multi-user.target
EOF
```
```
systemctl daemon-reload
systemctl enable avaxd
systemctl start avaxd
```
journalctl -fu avaxd -o cat -n 100
