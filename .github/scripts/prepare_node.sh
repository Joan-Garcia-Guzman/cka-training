#!/bin/bash
# Deactivate swap
sudo swapoff -a

# Make swapoff persistent
#sudo apt update && sudo apt install -y sed
sudo sed -i '/ swap / s/^/#/' /etc/fstab
# Make swapogg persisten using systemctl
#sudo systemctl mask swap.img.swap

# Reload systemctl daemon
sudo systemctl daemon-reload


# Enable IPv4 packet forwarding
cat /proc/sys/net/ipv4/ip_forward  # If returning 1, it's enabled
sudo tee /etc/sysctl.d/k8s.conf <<EOF
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
