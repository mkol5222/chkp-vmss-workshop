#!/bin/bash

VMSSNAME=$(az vmss list -g 58-vmss1 -o tsv --query '[0].{name:name}')
#az vmss  list-instance-public-ips -g 58-vmss1 -n $VMSSNAME -o table
VMSS2IP=$(az vmss  list-instance-public-ips -g 58-vmss1 -n $VMSSNAME -o json | jq -r '.[1].ipAddress')


sshpass -f <(echo "Welcome@Home#1984") ssh -o "StrictHostKeyChecking no" admin@$VMSS2IP
