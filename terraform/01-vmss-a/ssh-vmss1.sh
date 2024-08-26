#!/bin/bash

VMSSNAME=$(az vmss list -g 58-vmss1 -o tsv --query '[0].{name:name}')
#az vmss  list-instance-public-ips -g 58-vmss1 -n $VMSSNAME -o table
VMSS1IP=$(az vmss  list-instance-public-ips -g 58-vmss1 -n $VMSSNAME -o json | jq -r '.[0].ipAddress')
#VMSS2IP=$(az vmss  list-instance-public-ips -g 58-vmss1 -n $VMSSNAME -o json | jq -r '.[1].ipAddress')
#echo "VMSS IPs: $VMSS1IP $VMSS2IP"
sshpass -f <(echo "Welcome@Home#1984") ssh -o "StrictHostKeyChecking no" admin@$VMSS1IP
