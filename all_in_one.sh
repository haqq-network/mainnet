#!/bin/bash
# All-in-one Bash script for starting a Haqq node on Ubuntu LTS 22.04

# Check if a custom moniker is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <custom_moniker>"
  exit 1
fi

# Use the provided custom moniker
CUSTOM_MONIKER="$1"
HAQQD_DIR="$HOME/.haqqd"

echo "\n\n\n###############################################\n\n\n"
echo "Updating and installing required packages..."
echo "\n\n\n###############################################\n\n\n"

# Update and install required packages
sudo apt-get update -qq
sudo apt-get install -qq curl git make gcc liblz4-tool build-essential jq -y

echo "\n\n\n###############################################\n\n\n"
echo "Downloading installation scripts..."
echo "\n\n\n###############################################\n\n\n"

# Download installation scripts
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/install_go.sh
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/install_haqq.sh
curl -OL https://raw.githubusercontent.com/haqq-network/mainnet/master/init_start.sh

echo "\n\n\n###############################################\n\n\n"
echo "Installing Go language..."
echo "\n\n\n###############################################\n\n\n"

# Install Go language
sh install_go.sh

echo "Sourcing the Go environment variables..."
# Source the Go environment variables
. $HOME/.bash_profile

echo "\n\n\n###############################################\n\n\n"
echo "Installing the HAQQ node..."
echo "\n\n\n###############################################\n\n\n"

# Install the Haqq node
sh install_haqq.sh

echo "\n\n\n###############################################\n\n\n"
echo "Initializing and starting the Haqq node..."
echo "\n\n\n###############################################\n\n\n"

# Initialize and start the Haqq node
sh init_start.sh $CUSTOM_MONIKER $HAQQD_DIR
