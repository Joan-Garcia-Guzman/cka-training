# Initial cluster config
This episode is about creating a single node cluster, as a start.
To create the new cluster from scratch, you first need to install the kubernetes binaries and their prerequisits in each machine.

## Container runtime
You can use any CRI client, but commons are containerd (expected in the exam) and cri-o (found in official docs)

### Containerd
First enable the containerd components
```shell
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
```
Then activate them
```shell
sudo modprobe overlay
sudo modprobe br_netfilter
```
Overlay is the preferred system for storage in containers.
Br_netfilter is a module to proces network packets over the bridge interface.

Second enable network components
```shell
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
```

Third install containerd
```shell
sudo apt-get install -y containerd
```

> IMPORTANT!
> kubelet and container runtime MUST use the same systemdCgroup for proper resource limit management

So then configure the systemdCgroup
```shell
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
```

And finally restart containerd service
```shell
sudo systemctl restart containerd
sudo systemctl enable containerd
```

## Kubernetes binaries
This is not needed in the CKA exam, but just in case you need to fix nodes or install from scratch

First disable swap and configure it to persist across restarts
```shell
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```

Second install dependencies
```shell
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
 sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.37/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.37/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
```

Third install the binaries
```shell
sudo apt-get update
sudo apt-get install -y kubectl kubelet kubeadm
```
Don't restart any service for now

Fourth prevent accidental upgrades of the versions of the binaries
```shell
sudo apt-mark hold kubelet kubeadm kubectl
```

## Initialize the cluster
First register the machine as kubernetes control-plane of the cluster (remember to log into the machine using ssh, don't do it in your host machine)
```shell
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```
This CIDR is required by most CNI plugins

Second configure kubectl
```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Third install CNI plugin
```shell
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

Finally, check that the cluster is up and running
```shell
kubectl get nodes
kubectl get pods -n kube-system
```

## Summary
- Prepare the node (swap off && ip_forward)
- Install networking components (may be optional)
- Install container runtime
- Install kubernetes binaries
- Initialize cluster
- Install CNI plugin
- Validate cluster
