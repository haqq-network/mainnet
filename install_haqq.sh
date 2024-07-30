#!/bin/bash

# Install HAQQ 1.7.7

# Change directory to the user's home directory
cd $HOME

# Define the version of HAQQ to be installed
HAQQ_VERSION="v1.7.7"

# Clone the HAQQ repository for the specified version
git clone -b $HAQQ_VERSION https://github.com/haqq-network/haqq

# Change directory to the cloned repository
cd haqq

# Check deps
go mod tidy

# Compile and install HAQQ
make install

# Verify the installation by checking the version of HAQQ
if command -v haqqd >/dev/null; then
  echo "HAQQ version $(haqqd version) installed successfully."
else
  echo "HAQQ installation failed. Please check the installation process."
fi
