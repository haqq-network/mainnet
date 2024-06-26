#!/usr/bin/env bash
set -euo pipefail

# Check if a haqqd directory provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <haqqd_directory>"
  exit 1
fi

# Define the Tendermint RPC endpoint's of the HAQQ network
SNAP_RPC1="https://rpc.tm.haqq.network:443"
SNAP_RPC2="https://rpc.haqq.sh:443"

# Select one available SNAP_RPC
if curl -Is "$SNAP_RPC1/health" | head -n 1 | grep "200" > /dev/null; then
  echo "[INFO] SNAP_RPC1 ($SNAP_RPC1) is available and selected for requests"
  SNAP_RPC=$SNAP_RPC1
elif curl -Is "$SNAP_RPC2/health" | head -n 1 | grep "200" > /dev/null; then
  echo "[INFO] SNAP_RPC2 ($SNAP_RPC2) is available and selected for requests"
  SNAP_RPC=$SNAP_RPC2
else
  echo "[ERROR] Both SNAP_RPC1 and SNAP_RPC2 are not available. Exiting..."
  exit 1
fi

SNAP_RPC=$SNAP_RPC2

# Retrieve the latest block height of the HAQQ network
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)

# Calculate the height of the block to be trusted
BLOCK_HEIGHT=$((LATEST_HEIGHT - 10000))

# Retrieve the hash of the block to be trusted
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

# Define persistent peers
P_PEERS=""

# Define seed nodes
SEEDS="861e5892470275a394ebab407e8d62b1931843d3@192.248.181.17:26656,e1b058e5cfa2b836ddaa496b10911da62dcf182e@haqq-seed-de.allnodes.me:26656,e726816f42831689eab9378d5d577f1d06d25716@haqq-seed-us.allnodes.me:26656,0533e20e65912f72f2ad88a4c91eefbc634212d7@haqq-sync.rpc.p2p.world:26656,c45991e0098b9cacb8603caf4e1cdb7e6e5f87c0@eu.seed.haqq.network:26656,e37cb47590ba46b503269ef255873e9698244d8b@us.seed.haqq.network:26656,c593e93e1fb8be8b48d4e7bab514a227aa620bf8@as.seed.haqq.network:26656,0265238d4845e041868d610c100b88f485eeddfb@rpc.haqq.nodestake.top:666"

# Modify the HAQQ configuration file to add the trusted block and other parameters
sed -i.bak \
  -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
      s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
      s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
      s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
      s|^(persistent_peers[[:space:]]+=[[:space:]]+).*$|\1\"$P_PEERS\"| ; \
      s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"$SEEDS\"|" \
  $1/config/config.toml

# Print a message indicating that the configuration file has been updated
echo "HAQQ configuration file updated with the trusted block $BLOCK_HEIGHT ($TRUST_HASH)"
