#!/bin/bash

# propmt if run
echo "This script will remove the .terraform directory from the following directories:"
echo "01-vmss-a"
echo "04-cpman"
echo "03-reader"
echo "05-policy"
echo "11-ha2vmss"
echo "And it will also remove sp-random.txt and sp-random.txt."
echo "Do you want to continue? (y/n)"
read -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
rm -f ./sp-random.txt
rm -f ./sa-random.txt
rm -f ./reader.json
(cd ./01-vmss-a; rm -rf .terraform )
(cd ./04-cpman; rm -rf .terraform )
(cd ./03-reader; rm -rf .terraform )
(cd ./05-policy; rm -rf .terraform )
(cd ./11-ha2vmss; rm -rf .terraform )