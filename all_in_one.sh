#!/bin/bash
# All-in-one Bash script for starting a Haqq node on Ubuntu LTS 22.04

# Check if a custom moniker is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <custom_moniker>"
  exit 1
fi

# Use the provided custom moniker
CUSTOM_MONIKER="$1"

echo "Updating and installing required packages..."
# Update and install required packages
sudo apt-get update -qq
sudo apt-get install -qq curl git make gcc liblz4-tool build-essential jq -y

echo "Downloading installation scripts..."
# Download installation scripts
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/install_go.sh
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/install_haqq.sh
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/init_start.sh

echo "Installing Go language..."
# Install Go language
sh install_go.sh

echo "Sourcing the Go environment variables..."
# Source the Go environment variables
source $HOME/.bash_profile

echo "Installing the Haqq node..."
# Install the Haqq node
sh install_haqq.sh

echo "Initializing and starting the Haqq node..."
# Initialize and start the Haqq node
sh init_start.sh $CUSTOM_MONIKER
