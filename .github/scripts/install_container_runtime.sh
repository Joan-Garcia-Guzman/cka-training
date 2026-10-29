## Containerd

# Activate modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# Activate overlay
sudo modprobe overlay

# Activate bridge network filter
sudo modprobe br_netfilter

# Install containerd
sudo apt-get install -y containerd

# Configure containerd to use SystemdCgroup
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd
