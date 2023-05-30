# Haqq Network - MainNet


## Overview
The current version of the HAQQ MainNet is [`v1.3.1`](https://github.com/haqq-network/haqq/releases/tag/v1.3.1). To bootstrap a mainnet node, use State Sync and synchronize a snapshot from our official seed nodes.


## Quickstart
_*Battle tested on [Ubuntu LTS 22.04](https://spinupwp.com/doc/what-does-lts-mean-ubuntu/#:~:text=The%20abbreviation%20stands%20for%20Long,extended%20period%20over%20regular%20releases)*_

**All-in-one(tested on Ubuntu LTS):**

You can easily install all dependencies and the HAQQ node binary by using a single bash script.

```sh
CUSTOM_MONIKER="haqq_node" && \
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/all_in_one.sh && \
sudo sh all_in_one.sh "$CUSTOM_MONIKER"
```

**You can do the same yourself**

Install packages:
```sh
sudo apt-get update && \
sudo apt-get install curl git make gcc liblz4-tool build-essential jq -y
```

**Preresquisites for compile from source**
- `make` & `gcc` 
- `Go 1.19+` ([How to install Go](https://www.digitalocean.com/community/tutorials/how-to-install-go-on-ubuntu-20-04))

**Easy GO compiler and HAQQ node installation**

```sh
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/install_go.sh && \
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/install_haqq.sh && \
sh install_go.sh && \ 
source $HOME/.bash_profile && \
sh install_haqq.sh
```

**Do the same manually:**

Download latest binary for your arch: </br>
https://github.com/haqq-network/haqq/releases/tag/v1.3.1

Build from source:
```sh
cd $HOME
git clone -b v1.2.1 https://github.com/haqq-network/haqq
cd haqq
make install
```

Verify binary version:
```sh
haqq@haqq-node:~# haqqd -v
haqqd version "1.3.1" 877c235c1b86b0c734fb482fdebdec71bdc47b07
```

**Initialize and start HAQQ**

Run script:

```sh
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/init_start.sh && \
sh init_start.sh mainnet_node
```

_``mainnet_node``_ is argument value for custom moniker <br>

Manually:

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
