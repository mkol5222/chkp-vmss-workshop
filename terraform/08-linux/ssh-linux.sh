#!/bin/bash

pushd  /workspaces/chkp-vmss-workshop/terraform/08-linux
mkdir -p ~/.ssh
terraform output -raw ssh_key > ~/.ssh/linux.key
cat ~/.ssh/linux.key
chmod og= ~/.ssh/linux.key
terraform output -raw ssh_config
terraform output -raw ssh_config | tee  ~/.ssh/config
popd