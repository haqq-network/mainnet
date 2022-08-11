# Haqq Network // Mainet

## Overview

The current Haqq version of mainnet is [`v1.0.2`](https://github.com/haqq-network/haqq/releases/tag/v1.0.2). To bootstrap a mainnet node, it is possible to sync from v1.0.2 via State Sync.

## Quickstart

Install packages:
```sh
sudo apt-get install curl git make gcc liblz4-tool build-essential jq -y
```

**Preresquisites for compile from source**
- `make` & `gcc` 
- `Go 1.16+` ([How to install Go](https://www.digitalocean.com/community/tutorials/how-to-install-go-on-ubuntu-20-04))

Download latest binary for your arch: </br>
https://github.com/haqq-network/haqq/releases/tag/v1.0.2

Build from source:
```sh
cd $HOME
git clone -b v1.0.2 https://github.com/haqq-network/haqq
cd haqq
make install
```

Check binary version:
```sh
haqq@haqq-node:~# haqqd -v
haqqd version "1.0.2" a134b9137beae737acbdbd5f4f19f7fe46c91081
```

```sh
CUSTOM_MONIKER="mainnet_node"

haqqd config chain-id haqq_11235-1 && \
haqqd init CUSTOM_MONIKER --chain-id haqq_11235-1

# Prepare genesis file for mainet(haqq_11235-1)
curl -OL https://gist.githubusercontent.com/kioqq/13f56710b3e932f9d12cc5c56f4f81f0/raw/da734a7a500aca4eb048899585302d9026b7b5b7/genesis.json
mv genesis.json $HOME/.haqqd/config/genesis.json

# Configure State sync
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/state_sync.sh
sh state_sync.sh

# Start Haqq
haqqd start --x-crisis-skip-assert-invariants
```

## Upgrade to Validator Node
TBD
