#!/bin/bash

VMSSNAME=$(az vmss list -g 58-vmss1 -o tsv --query '[0].{name:name}')
watch -d az vmss  list-instance-public-ips -g 58-vmss1 -n $VMSSNAME -o table