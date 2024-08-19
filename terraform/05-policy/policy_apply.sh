#!/bin/bash

export TF_VAR_server=$(cd 04-cpman/; terraform show -json | jq -r '.values.root_module.child_modules[0].resources[]|select(.address=="module.cpman.azurerm_public_ip.public-ip")|.values.ip_address' )
echo "Server IP: $TF_VAR_server"

(cd ./05-policy && terraform init -backend-config "storage_account_name=58tfbackend21745$(cat ../sa-random.txt)" && terraform apply -auto-approve)

sleep 5
(cd ./05-policy && terraform apply -auto-approve -var publish=true)
