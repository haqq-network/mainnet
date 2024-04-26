#!/bin/bash

## This Bash script installs Go version 1.20.2 on a Linux system by downloading the Go binary tarball for the specified version, extracting it to the /usr/local directory, and adding the Go binaries to the PATH environment variable.

# Change directory to the user's home directory
cd $HOME

# Define the version of Go to be installed
GO_VERSION="1.21.9"

# Download the Go binary tarball for the specified version
wget "https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz"

# Remove any previous installation of Go
sudo rm -rf /usr/local/go

# Extract the Go binary tarball to /usr/local directory
sudo tar -C /usr/local -xzf "go$GO_VERSION.linux-amd64.tar.gz"

# Remove the downloaded tarball
rm "go$GO_VERSION.linux-amd64.tar.gz"

# Add Go binaries to the PATH and source the .bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >>$HOME/.bash_profile
. $HOME/.bash_profile

# Verify the installation by checking the version of Go
if command -v go >/dev/null; then
  echo "Go version $(go version) installed successfully."
else
  echo "Go installation failed. Please check the installation process."
fi
