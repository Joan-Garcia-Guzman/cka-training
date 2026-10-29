# Fail if errors
set -e
set -o pipefail

# Capture arguments
VB_VERSION=$1

if [ -z "$VB_VERSION" ]; then
    echo "Error: You must provide the virtualbox version to install as an argument."
    exit 1
fi

# Config Hashicorp repo
echo "retrieving Hashicorp keyring..."
curls -fsSL https://virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes -o /usr/share/keyrings/oracle-virtualbox-2016.gpg
echo "updating apt..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
# Update runner
sudo apt update
# Install vagrant
sudo apt install -y virtualbox="$VB_VERSION-1"
vboxmanage --version