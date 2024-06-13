# Haqq Network - MainNet


## Overview
The current version of the HAQQ MainNet is [`v1.7.6`](https://github.com/haqq-network/haqq/releases/tag/v1.7.6). To bootstrap a mainnet node, use State Sync and synchronize a snapshot from our official seed nodes.


## Quickstart
_*Battle tested on [Ubuntu LTS 22.04](https://spinupwp.com/doc/what-does-lts-mean-ubuntu/#:~:text=The%20abbreviation%20stands%20for%20Long,extended%20period%20over%20regular%20releases)*_

**You can do the same yourself**

Install packages:
```sh
sudo apt-get update && \
sudo apt-get install curl git make gcc liblz4-tool build-essential git-lfs jq -y
```

**Preresquisites for compile from source**
- `make` & `gcc` 
- `Go 1.21+` ([How to install Go](https://www.digitalocean.com/community/tutorials/how-to-install-go-on-ubuntu-20-04))

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
https://github.com/haqq-network/haqq/releases/tag/v1.7.6

Build from source:
```sh
cd $HOME
git clone -b v1.7.6 https://github.com/haqq-network/haqq
cd haqq
make install
```

Verify binary version:
```sh
haqq@haqq-node:~# haqqd -v
haqqd version "1.7.6 6c2cce73614ecff317f3569593176c9e4938c6a6
```

**Initialize and start HAQQ**

```sh
export CUSTOM_MONIKER="mainnet_seed_node"
export HAQQD_DIR="$HOME/.haqqd"

haqqd config chain-id haqq_11235-1 && \
haqqd init $CUSTOM_MONIKER --chain-id haqq_11235-1

# Prepare genesis file for mainet(haqq_11235-1)
curl -L https://raw.githubusercontent.com/haqq-network/mainnet/master/genesis.json -o $HAQQD_DIR/config/genesis.json

# Prepare addrbook
curl -L https://raw.githubusercontent.com/haqq-network/mainnet/master/addrbook.json -o $HAQQD_DIR/config/addrbook.json

# Configure State sync
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/state_sync.sh && \
chmod +x state_sync.sh && \
./state_sync.sh $HAQQD_DIR

# Start Haqq
haqqd start
```

## Cosmovisor setup

1. Install cosmovisor bin
```sh
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest
```

2. Create cosmovisor folders
```sh
mkdir -p $HAQQD_DIR/cosmovisor/genesis/bin && \
mkdir -p $HAQQD_DIR/cosmovisor/upgrades
```

3. Copy node binary into Cosmovisor folder
```sh
cp $HOME/go/bin/haqqd $HAQQD_DIR/cosmovisor/genesis/bin
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
User=<your user>
ExecStart=/home/<your user>/go/bin/cosmovisor run start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=haqqd"
Environment="DAEMON_HOME=$HAQQD_DIR"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=false"

[Install]
WantedBy=multi-user.target
```

5. Enable and start service

```sh
sudo systemctl enable haqqd.service && \
sudo systemctl start haqqd.service
```

6. Check logs
```sh
sudo journalctl --system -fu haqqd
```
