#!/bin/bash

# Define the RPC endpoint of the HAQQ network
SNAP_RPC="https://rpc.tm.haqq.network:443"

# Retrieve the latest block height of the HAQQ network
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)

# Calculate the height of the block to be trusted
BLOCK_HEIGHT=$((LATEST_HEIGHT - 5000))

# Retrieve the hash of the block to be trusted
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

# Define persistent peers
P_PEERS=""

# Define seed nodes
SEEDS="731f27fe9cd05257fcfc68b96147aec79035f920@seed1.haqq.network:26656,681da1f78742b2a0f8e0e7dac6e6f72166d82a8c@seed2.haqq.network:26656,d8e2d0095763ed3c6f38814e7752eccc3c547913@167.235.199.131:26656"

# Modify the HAQQ configuration file to add the trusted block and other parameters
sed -i.bak \
  -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
      s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
      s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
      s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
      s|^(persistent_peers[[:space:]]+=[[:space:]]+).*$|\1\"$P_PEERS\"| ; \
      s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"$SEEDS\"|" \
  $HOME/.haqqd/config/config.toml

# Print a message indicating that the configuration file has been updated
echo "HAQQ configuration file updated with the trusted block $BLOCK_HEIGHT ($TRUST_HASH)"
