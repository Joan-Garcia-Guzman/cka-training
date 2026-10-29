# Fail if errors
set -e
set -o pipefail

# Capture arguments
VB_VERSION=$1

if [ -z "$VAGRANT_VERSION" ]; then
    echo "Error: You must provide the vagrant version to install as an argument."
    exit 1
fi

# Config Hashicorp repo
echo "retrieving Hashicorp keyring..."
#curl -fsSL https://hashicorp.com | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
wget --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 --tries=5 -q https://virtualbox.org -O- | sudo gpg --dearmor -o /etc/apt/keyrings/virtualbox.gpg
echo "updating apt..."
sudo add-apt-repository "deb [arch=amd64 signed-by=/etc/apt/keyrings/virtualbox.gpg] https://virtualbox.org $(lsb_release -sc) contrib"
# Update runner
sudo apt update
# Install vagrant
sudo apt install -y vagrant="$VAGRANT_VERSION-1"
vagrant --version