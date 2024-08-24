#!/bin/bash

# prompt for deletion
read -p "Delete tfbackend storage? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Exiting"
  exit 1
fi

RESOURCE_GROUP_NAME=58-tfbackend
STORAGE_ACCOUNT_NAME="58tfbackend21745$(cat ./sa-random.txt)"
CONTAINER_NAME=tfstate

# Delete blob container
az storage container delete --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

# Delete storage account
az storage account delete --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --yes

# Delete resource group
az group delete --name $RESOURCE_GROUP_NAME --yes

echo "Deleted tfbackend storage"