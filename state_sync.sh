#!/bin/bash

SNAP_RPC="https://rpc.tm.haqq.network:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

# persistent_peers
P_PEERS=""

# seed nodes
SEEDS="9578a7c58cd91724c639aaf2ff5a01a35ce6e705@34.91.100.34:26656,ecb2274dbef5350270d3e21175b31746350cdc37@34.141.202.93:26656,4dddc284c0aa3373b3f73da95e989a607f37ee26@35.204.156.167:26656"

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(persistent_peers[[:space:]]+=[[:space:]]+).*$|\1\"$P_PEERS\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"$SEEDS\"|" $HOME/.haqqd/config/config.toml