#!/bin/bash

export VAGRANT_CWD="../../infra/local"

vagrant destroy -f k8s-master
