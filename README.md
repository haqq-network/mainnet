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
- `Go 1.18+` ([How to install Go](https://www.digitalocean.com/community/tutorials/how-to-install-go-on-ubuntu-20-04))

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
CUSTOM_MONIKER="mainnet_node"

haqqd config chain-id haqq_11235-1 && \
haqqd init CUSTOM_MONIKER --chain-id haqq_11235-1

# Prepare genesis file for mainet(haqq_11235-1)
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/genesis.json
mv genesis.json $HOME/.haqqd/config/genesis.json

# Configure State sync
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/state_sync.sh
sh state_sync.sh

# Start Haqq
haqqd start --x-crisis-skip-assert-invariants
```

## Upgrade to Validator Node
TBD
