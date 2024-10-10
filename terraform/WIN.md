```shell

# pwsh
Get-AzVmImageSku -Location 'northeurope' -PublisherName 'MicrosoftWindowsDesktop' -Offer 'Windows-11'
# sku win11-24h2-pro 

resourcegroup="win11"
location="northeurope"
az group create --name $resourcegroup --location $location

az network vnet list -o table
# vmss1 58-vmss1 northeurope (10.1.0.0/16)

az network vnet subnet list --resource-group 58-vmss1 --vnet-name vmss1 -o table
# 10.1.107.0/24 for win
az network vnet subnet create --resource-group 58-vmss1 --vnet-name vmss1 --name win11 --address-prefix 10.1.107.0/24

# routing table for win11 subnet
az network route-table create --name win11 --resource-group 58-vmss1
# route to internet via VMSS1 10.1.2.4
az network route-table route create --name Internet --resource-group 58-vmss1 --route-table-name win11 --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address 10.1.2.4
# assiciate route table with win11 subnet
az network vnet subnet update --resource-group 58-vmss1 --vnet-name vmss1 --name win11 --route-table win11

RDPCLIENT=88.1.2.3
# back to RDP client via Internet
az network route-table route create --name rdp --resource-group 58-vmss1 --route-table-name win11 --address-prefix $RDPCLIENT/32 --next-hop-type Internet

az network route-table route list --resource-group 58-vmss1 --route-table-name win11


vmname="win11"
username="chkp"
az vm create \
    --resource-group 58-vmss1 \
    --name $vmname \
    --image MicrosoftWindowsDesktop:Windows-11:win11-24h2-pro:latest \
    --public-ip-sku Standard \
    --admin-username $username \
    --vnet-name vmss1 \
    --subnet win11 \
    --size Standard_B2ms


# delete VM
az vm delete --resource-group 58-vmss1 --name win11 --yes
# disassociate route table
az network vnet subnet update --resource-group 58-vmss1 --vnet-name vmss1 --name win11 --route-table ""
az network vnet subnet delete --resource-group 58-vmss1 --vnet-name vmss1 --name win11
az network route-table delete --resource-group 58-vmss1 --name win11


# "Publisher:Offer:Sku:Version"

# PS /home/martin> Get-AzVmImageSku -Location 'northeurope' -PublisherName 'MicrosoftWindowsDesktop' -Offer 'Windows-11' | ? Skus -eq win11-24h2-pro | select Id


# Id
# --
# /Subscriptions/******/Providers/Microsoft.Compute/Locations/northeurope/Publishers/MicrosoftWindowsDesktop/ArtifactTypes/VMImage/Offers/windows-11/Skus/win11-24h2-pro