#!/bin/bash

set -euo pipefail

. ./00-azsp/spname.sh

SPID=$(az ad sp list --display-name "$SPNAME" --query "[].{id:appId}" -o tsv)
echo "Checked existing SP id: $SPID"

# stop id SPID exists (not empty string)
if [ -z "$SPID" ]; then
  echo "SP $SPNAME does not exist, exiting"
  exit 1
fi

# prompt for deletion
read -p "Delete SP $SPNAME? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Exiting"
  exit 1
fi

echo "Deleting SP $SPNAME"
az ad sp delete --id $SPID
rm -f sp.yaml