# Capture arguments
VAGRANT_VERSION=$1

if [ -z "$VAGRANT_VERSION" ]; then
    echo "Error: You must provide the vagrant version to install as an argument."
    exit 1
fi

# Config Hashicorp repo
curl -fsSL https://hashicorp.com | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
# Update runner
sudo apt-get update
# Install vagrant
sudo apt-get install -y vagrant="$VAGRANT_VERSION"