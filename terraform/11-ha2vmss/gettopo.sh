#!/bin/bash

# az network nic show -g  58-ha2vmss -n ha1-eth0 | jq -r '.ipConfigurations[0]'
# az network nic show -g  58-ha2vmss -n ha1-eth0 | jq -r '.ipConfigurations[0].publicIPAddress.id'

# VIP
VIP=$(az network nic show -g  58-ha2vmss -n ha1-eth0 | jq -r '.ipConfigurations[1].privateIPAddress')
VIP_PUB=$(az network public-ip show --ids $(az network nic show -g  58-ha2vmss -n ha1-eth0 | jq -r '.ipConfigurations[1].publicIPAddress.id') | jq -r '.ipAddress')
echo "VIP: $VIP ($VIP_PUB)"

# HA1
HA1_ETH0=$(az network nic show -g  58-ha2vmss -n ha1-eth0 | jq -r '.ipConfigurations[0].privateIPAddress')
HA1_ETH0_PUB=$(az network public-ip show --ids $(az network nic show -g  58-ha2vmss -n ha1-eth0 | jq -r '.ipConfigurations[0].publicIPAddress.id') | jq -r '.ipAddress')
HA1_ETH1=$(az network nic show -g  58-ha2vmss -n ha1-eth1 | jq -r '.ipConfigurations[0].privateIPAddress')
echo "HA1: $HA1_ETH0 ($HA1_ETH0_PUB) $HA1_ETH1"

# HA2
HA2_ETH0=$(az network nic show -g  58-ha2vmss -n ha2-eth0 | jq -r '.ipConfigurations[0].privateIPAddress')
HA2_ETH0_PUB=$(az network public-ip show --ids $(az network nic show -g  58-ha2vmss -n ha2-eth0 | jq -r '.ipConfigurations[0].publicIPAddress.id') | jq -r '.ipAddress')
HA2_ETH1=$(az network nic show -g  58-ha2vmss -n ha2-eth1 | jq -r '.ipConfigurations[0].privateIPAddress')
echo "HA2: $HA2_ETH0 ($HA2_ETH0_PUB) $HA2_ETH1"

# whole table
cat <<EOF
NIC  VIP             VIP Public      HA1             HA1 Public      HA2             HA2 Public
---- --------------- --------------- --------------- --------------- --------------- ---------------
eth0 $(printf '%-15s' "$VIP") $(printf '%-15s' "$VIP_PUB") $(printf '%-15s' "$HA1_ETH0") $(printf '%-15s' "$HA1_ETH0_PUB") $(printf '%-15s' "$HA2_ETH0") $(printf '%-15s' "$HA2_ETH0_PUB")
eth1 $(printf '%-15s' " ") $(printf '%-15s' " ") $(printf '%-15s' "$HA1_ETH1") $(printf '%-15s' "$HA2_ETH1")
EOF

echo
echo 

# add-simple-cluster.sh

cat <<EOF
# Add simple cluster
mgmt_cli -r true add simple-cluster name "ha2vmss"\
    color "pink"\
    version "R81.20"\
    ip-address "${VIP_PUB}"\
    os-name "Gaia"\
    cluster-mode "cluster-xl-ha"\
    firewall true\
    vpn false\
    interfaces.1.name "eth0"\
    interfaces.1.ip-address "${HA1_ETH0_PUB}"\
    interfaces.1.network-mask "255.255.255.0"\
    interfaces.1.interface-type "cluster + sync"\
    interfaces.1.topology "EXTERNAL"\
    interfaces.1.anti-spoofing false \
    interfaces.2.name "eth1"\
    interfaces.2.interface-type "sync"\
    interfaces.2.topology "INTERNAL"\
    interfaces.2.topology-settings.ip-address-behind-this-interface "network defined by the interface ip and net mask"\
    interfaces.2.topology-settings.interface-leads-to-dmz false\
    interfaces.2.anti-spoofing false \
    members.1.name "ha1"\
    members.1.one-time-password "welcomehome1984"\
    members.1.ip-address "${HA1_ETH0_PUB}"\
    members.1.interfaces.1.name "eth0"\
    members.1.interfaces.1.ip-address "${HA1_ETH0}"\
    members.1.interfaces.1.network-mask "255.255.255.0"\
    members.1.interfaces.2.name "eth1"\
    members.1.interfaces.2.ip-address "${HA1_ETH1}"\
    members.1.interfaces.2.network-mask "255.255.255.0"\
    members.2.name "ha2"\
    members.2.one-time-password "welcomehome1984"\
    members.2.ip-address "${HA2_ETH0_PUB}"\
    members.2.interfaces.1.name "eth0"\
    members.2.interfaces.1.ip-address "${HA2_ETH0}"\
    members.2.interfaces.1.network-mask "255.255.255.0"\
    members.2.interfaces.2.name "eth1"\
    members.2.interfaces.2.ip-address "${HA2_ETH1}"\
    members.2.interfaces.2.network-mask "255.255.255.0"\
    --format json
EOF



