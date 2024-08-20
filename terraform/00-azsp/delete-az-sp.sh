#!/bin/bash

set -euo pipefail

. ./00-azsp/spname.sh
SPPREFIX=$(cat ./sp-random.txt)
FULLSPNAME="$SPPREFIX$SPNAME"
# az ad sp list --display-name 58-cross-region-lb -o json | jq -r '.[] | select (."displayName"== "58-cross-region-lb-pkr")

# not exact match!!! (matches substring of name too!)
SPID=$(az ad sp list --display-name "$FULLSPNAME" --query "[].{id:appId}" -o tsv)
echo "Checked existing SP id: $SPID"

# stop id SPID exists (not empty string)
if [ -z "$SPID" ]; then
  echo "SP $FULLSPNAME does not exist, exiting"
  exit 1
fi

# prompt for deletion
read -p "Delete SP $FULLSPNAME? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Exiting"
  exit 1
fi

echo "Deleting SP $FULLSPNAME"
az ad sp delete --id $SPID
rm -f sp.yaml