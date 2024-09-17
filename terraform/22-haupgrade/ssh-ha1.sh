#!/bin/bash

HA1_ETH0_PUB=$(az network public-ip show --ids $(az network nic show -g  58-ha2vmss -n ha1-eth0 | jq -r '.ipConfigurations[0].publicIPAddress.id') | jq -r '.ipAddress')
sshpass -f <(echo "Welcome@Home#1984") ssh -o "StrictHostKeyChecking no" admin@$HA1_ETH0_PUB