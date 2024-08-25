#!/bin/bash

HA2_ETH0_PUB=$(az network public-ip show --ids $(az network nic show -g  58-ha2vmss -n ha2-eth0 | jq -r '.ipConfigurations[0].publicIPAddress.id') | jq -r '.ipAddress')
sshpass -f <(echo "Welcome@Home#1984") ssh -o "StrictHostKeyChecking no" admin@$HA2_ETH0_PUB