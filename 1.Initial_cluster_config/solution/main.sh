#!/bin/bash

# Script setup
set -euo pipefail
export VAGRANT_CWD="../../infra/local"
cleanup() {
    echo "Running cleanup"
    ./cleanup.sh
}
trap cleanup EXIT

## On your host
echo "Starting up VMs"
vagrant up k8s-master

## Inside VM - k8s-master
echo "Executing Step by step solution"
vagrant ssh k8s-master -- -T /bin/bash < ./step-by-step.sh

## Execute automated tests
echo "Running automated tests"
echo "waiting 60s to let the cluster initiate"
sleep 60
vagrant ssh k8s-master -- -T /bin/bash < ./validation.sh
