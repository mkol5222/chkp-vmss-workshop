#!/bin/bash

# get (read-only) credentials to list VMSS in Azure 
CLIENT_ID=$(cat ./reader.json | jq -r .client_id)
CLIENT_SECRET=$(cat ./reader.json | jq -r .client_secret)
TENANT_ID=$(cat ./reader.json | jq -r .tenant_id)
SUBSCRIPTION_ID=$(cat ./reader.json | jq -r .subscription_id)

# get management server IP
export TF_VAR_server=$(cd 04-cpman/; terraform show -json | jq -r '.values.root_module.child_modules[0].resources[]|select(.address=="module.cpman.azurerm_public_ip.public-ip")|.values.ip_address' )
echo "Server IP: $TF_VAR_server"
echo "Note: you may enter Security Management using \"make ssh\" too"
echo

# configure CME for VMSS - use real credentials!!! (example below is revoked RO Az SP)
# command to run @cpman
echo "Run these commands one by one at cpman SSH prompt." 
echo "  Hint: No need to restart CME after fist command"
echo
echo autoprov_cfg init Azure -mn mgmt -tn vmss_template -otp welcomehome1984 -ver R81.20 -po Azure -cn ctrl -sb $SUBSCRIPTION_ID -at $TENANT_ID -aci $CLIENT_ID -acs "$CLIENT_SECRET"
echo 
echo autoprov_cfg set template -tn vmss_template -ia -ips
echo
echo 'tail -f /var/log/CPcme/cme.log'
echo 
echo "Enter cpman to run commands above using: ssh admin@$TF_VAR_server or make ssh"
echo

