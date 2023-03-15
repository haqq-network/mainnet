# Haqq Network // Mainnet

## Overview

The current Haqq version of mainnet is [`v1.2.1`](https://github.com/haqq-network/haqq/releases/tag/v1.2.1). To bootstrap a mainnet node, it is possible to sync from v1.2.1 via State Sync.

## Quickstart

Install packages:
```sh
sudo apt-get install curl git make gcc liblz4-tool build-essential jq -y
```

**Preresquisites for compile from source**
- `make` & `gcc` 
- `Go 1.19+` ([How to install Go](https://www.digitalocean.com/community/tutorials/how-to-install-go-on-ubuntu-20-04))

Download latest binary for your arch: </br>
https://github.com/haqq-network/haqq/releases/tag/v1.2.1

Build from source:
```sh
cd $HOME
git clone -b v1.2.1 https://github.com/haqq-network/haqq
cd haqq
make install
```

Check binary version:
```sh
haqq@haqq-node:~# haqqd -v
haqqd version "1.2.1" 4d25b4ae8c52011a64c7279454e88c372f515673
```

```sh
CUSTOM_MONIKER="mainnet_seed_node" && \
haqqd config chain-id haqq_11235-1 && \
haqqd init $CUSTOM_MONIKER --chain-id haqq_11235-1

# Prepare genesis file for mainet(haqq_11235-1)
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/genesis.json && \
mv genesis.json $HOME/.haqqd/config/genesis.json

# Configure State sync
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/state_sync.sh && \
sh state_sync.sh

# Start Haqq
haqqd start
```

## Cosmovisor setup

1. Install cosmovisor bin
```sh
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@latest
```

2. Create cosmovisor folders
```sh
mkdir $HOME/.haqqd/cosmovisor && \
mkdir -p $HOME/.haqqd/cosmovisor/genesis/bin && \
mkdir -p $HOME/.haqqd/cosmovisor/upgrades
```

3. Copy node binary into Cosmovisor folder
```sh
cp /root/go/bin/haqqd $HOME/.haqqd/cosmovisor/genesis/bin
```

4. Create haqqd cosmovisor service
```sh
nano /etc/systemd/system/haqqd.service
```

```sh
[Unit]
Description="haqqd cosmovisor"
After=network-online.target

[Service]
User=root
ExecStart=/root/go/bin/cosmovisor run start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=haqqd"
Environment="DAEMON_HOME=/root/.haqqd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=false"

[Install]
WantedBy=multi-user.target
```

5. Enable and start service

```sh
systemctl enable haqqd.service && \
systemctl start haqqd.service
```

6. Check logs
```sh
journalctl -fu haqqd
```
