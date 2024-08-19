#!/bin/bash


CLIENT_ID=$(cat ./reader.json | jq -r .client_id)
CLIENT_SECRET=$(cat ./reader.json | jq -r .client_secret)
TENANT_ID=$(cat ./reader.json | jq -r .tenant_id)
SUBSCRIPTION_ID=$(cat ./reader.json | jq -r .subscription_id)

export TF_VAR_server=$(cd 04-cpman/; terraform show -json | jq -r '.values.root_module.child_modules[0].resources[]|select(.address=="module.cpman.azurerm_public_ip.public-ip")|.values.ip_address' )
echo "Server IP: $TF_VAR_server"

# configure CME for VMSS - use real credentials!!! (example below is revoked RO Az SP)
# command to run @cpman
echo
echo autoprov_cfg init Azure -mn mgmt -tn vmss_template -otp welcomehome1984 -ver R81.20 -po Azure -cn ctrl -sb $SUBSCRIPTION_ID -at $TENANT_ID -aci $CLIENT_ID -acs "$CLIENT_SECRET"
echo autoprov_cfg set template -tn vmss_template -ia -ips
echo

echo "ssh admin@$TF_VAR_server"
echo

echo 'setup and then monitor with: tail -f /var/log/CPcme/cme.log'