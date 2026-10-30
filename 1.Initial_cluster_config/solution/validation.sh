#!/bin/bash

set -u

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Running tests... ===${NC}\n"

echo "1. Checking cluster info..."
if kubectl cluster-info &> /dev/null; then
    echo -e "   [${GREEN}OK${NC}] The kubernetes API server is answering correctly.\n"
else
    echo -e "   [${RED}FAIL${NC}] Can't connect to the kubernetes API server.\n"
    exit 1
fi

echo "2. Checking cluster nodes..."
kubectl get nodes
READY_NODES=$(kubectl get nodes --no-headers | grep -c "Ready")
if [ "$READY_NODES" -eq 1 ]; then
    echo -e "   [${GREEN}OK${NC}] All nodes are Ready.\n"

else
    echo -e "   [${RED}FAIL${NC}] There are failing nodes.\n"
    exit 1
fi

echo "3. Checking system pods (kube-system y kube-flannel)..."
kubectl get pods -A
FAILED_PODS=$(kubectl get pods -A --no-headers | grep -E -v -c "Running|Completed")
if [ "$FAILED_PODS" -eq 0 ]; then
    echo -e "   [${GREEN}OK${NC}] All system pods are Running or Completed.\n"
    kubectl get pods -A
else
    echo -e "   [${RED}FAIL${NC}] There are some system pods with errors.\n"
    exit 1
fi

echo -e "${GREEN}=== All OK ===${NC}"
