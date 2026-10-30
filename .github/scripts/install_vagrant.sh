#!/bin/bash
# Fail if errors
set -e
set -o pipefail

# Capture arguments
VAGRANT_VERSION=$1

if [ -z "$VAGRANT_VERSION" ]; then
    echo "Error: You must provide the vagrant version to install as an argument."
    exit 1
fi

# Config Hashicorp repo
echo "retrieving Hashicorp keyring..."
#curl -fsSL https://hashicorp.com | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
wget --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 --tries=5 -qO /tmp/hashicorp.gpg https://apt.releases.hashicorp.com/gpg
sudo mkdir -p /usr/share/keyrings
sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg /tmp/hashicorp.gpg
echo "updating apt..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
# Update runner
sudo apt update
# Install vagrant
sudo apt install -y vagrant="$VAGRANT_VERSION-1"
vagrant --version