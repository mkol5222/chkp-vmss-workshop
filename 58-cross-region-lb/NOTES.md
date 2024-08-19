# 58-cross-region-lb

```bash
cd /workspaces/chkp-vmss-workshop58-cross-region-lb

# check AZ permissions
az account list -o table
# if not logged in
az login
az account list -o table

# all TF requires authenticad Azure API access - we do it based in Service Principal
# lets create SP first

cd /workspaces/chkp-vmss-workshop58-cross-region-lb
make sp
# it was stored here and used by rest of TF code
cat sp.yaml

# tf state should be remote, we need storage for it - storage account name has to be globally unique!!! (visit script for details)
cd /workspaces/chkp-vmss-workshop58-cross-region-lb
make tfbackend

# deployment of VMSS is easy
# I have studied documentation of VMSS readme, cut&paste and customize few elements
# see https://github.com/CheckPointSW/CloudGuardIaaS/tree/master/terraform/azure/vmss-new-vnet
cd /workspaces/chkp-vmss-workshop58-cross-region-lb
(cd /workspaces/chkp-vmss-workshop58-cross-region-lb/01-vmss-a; rm -rf .terraform )
make vmss1

# policy is pushed from management server. Lets get one in Azure
# can be done in parallel to VMSS deployment - in one more terminal
cd /workspaces/chkp-vmss-workshop58-cross-region-lb
(cd /workspaces/chkp-vmss-workshop58-cross-region-lb/04-cpman; rm -rf .terraform )
make cpman
# BTW code was also created by cut&paste from readme at
# https://github.com/CheckPointSW/CloudGuardIaaS/tree/master/terraform/azure/management-new-vnet


# reader SP would be useful for Azure inventory integration and CME - to bootstrap VMSS gw instances as they are created (e.g. on scale out)
cd /workspaces/chkp-vmss-workshop58-cross-region-lb
(cd /workspaces/chkp-vmss-workshop58-cross-region-lb/03-reader; rm -rf .terraform )
make reader
# reader is temporary SP, used only for inventory and CME - stored here
cat reader.json | jq .
# other TF code and CME will use it later

# lets check if VMSS is up and running
az group list --output table | grep 58-
az vmss list --resource-group 58-vmss1 --output table

# lets check if management server is up and running
az group list --output table | grep 58-
az vm list --resource-group 58-cpman --output table
# what is cpman IP?
az vm list-ip-addresses  -o json | jq -r '.[] | select(.virtualMachine.name == "cpman") | .virtualMachine.network.publicIpAddresses[0].ipAddress'
# user is admin, password is Welcome@Home#1984 ;-) - lets login
CPMAN_IP=$(az vm list-ip-addresses  -o json | jq -r '.[] | select(.virtualMachine.name == "cpman") | .virtualMachine.network.publicIpAddresses[0].ipAddress')

echo $CPMAN_IP
ssh admin@$CPMAN_IP
ssh admin@$CPMAN_IP tail -f  /var/log/cloud_config.log 
ssh admin@$CPMAN_IP cat  /var/log/cloud_config.log 
# visit cpman VM in Azure portal and check serial console
# https://portal.azure.com/#browse/Microsoft.Compute%2FVirtualMachines

# you schould see FTCW and cloud-init logs done first
# then you may continue ...
ssh admin@$CPMAN_IP cat /var/log/cloud_config.log 

# confirm Mgmt is ready once API is ready
ssh admin@$CPMAN_IP api status
# under "Overall API Status:"

# once it is the case, we may apply policy
cd /workspaces/chkp-vmss-workshop58-cross-region-lb
(cd /workspaces/chkp-vmss-workshop58-cross-region-lb/05-policy; rm -rf .terraform )
cat ./05-policy/policy_apply.sh
make policy

# publish
export TF_VAR_server=$(cd 04-cpman/; terraform show -json | jq -r '.values.root_module.child_modules[0].resources[]|select(.address=="module.cpman.azurerm_public_ip.public-ip")|.values.ip_address' )
(cd ./05-policy && terraform apply -auto-approve -var publish=true)

# also start SmartConsole and inspect new policy package called Azure; 
# see user sessions and potential uncommited changes
echo $CPMAN_IP

# once policy is in place, we need VMSS gw instances to be added to management by CME
cd /workspaces/chkp-vmss-workshop58-cross-region-lb
make cme

# this returned commands to be run on management server

# ssh to cpman
CPMAN_IP=$(az vm list-ip-addresses  -o json | jq -r '.[] | select(.virtualMachine.name == "cpman") | .virtualMachine.network.publicIpAddresses[0].ipAddress')
# Welcome@Home#1984
ssh admin@$CPMAN_IP

# cut and paste 2 autoprov_cfg commands
# copy one by one and restart CME only after second command
# once CME is restarted, you may check status
find /var -name cme.log
tail -f /var/log/CPcme/cme.log

### linux1 VM
cd /workspaces/chkp-vmss-workshop58-cross-region-lb/08-linux
make up
make fwon
mkdir -p ~/.ssh
tf output -raw ssh_key > ~/.ssh/linux.key
cat ~/.ssh/linux.key
chmod og= ~/.ssh/linux.key
tf output -raw ssh_config
tf output -raw ssh_config | tee  ~/.ssh/config
# should get Ubuntu machine prompt
ssh linux
# linux
curl ip.iol.cz/ip/
ping -c 3 1.1.1.1
ping -c 3 8.8.8.8


# new VMSS instance(s) should be added to management - appear in SmartConsole
# policy package Azure is pushed to them...

##########################################
# CLEANUP

# linux1 VM
cd /workspaces/chkp-vmss-workshop58-cross-region-lb/08-linux
make down

# remove reader SP permissions
cd /workspaces/chkp-vmss-workshop58-cross-region-lb
make reader-down

# remove management server
cd /workspaces/chkp-vmss-workshop58-cross-region-lb
make cpman-down

# lets remove gateways in VMSS
cd /workspaces/chkp-vmss-workshop58-cross-region-lb
make vmss1-down

# as last step, remove SP used for TF
cd /workspaces/chkp-vmss-workshop58-cross-region-lb
make sp-down

# storage account used for TF state
cd /workspaces/chkp-vmss-workshop58-cross-region-lb
make tfbackend-down

# note there was also shorter way to remove all resources
make down

# inspect related RGs (none should be left)
az group list --output table | grep 58-

```


### Unused:
```bash


# CME helpers on cpman
curl_cli -k -OL https://raw.githubusercontent.com/joe-at-cp/checkpoint-cme-helper/main/cme_helper.sh
curl_cli -k -OL https://raw.githubusercontent.com/joe-at-cp/checkpoint-cme-helper/main/gw_helper.sh
autoprov_cfg set management -cs /home/admin/cme_helper.sh
autoprov_cfg set template -tn vmss_template -ia -ips -cg /home/admin/gw_helper.sh

# yq
# curl -OL https://github.com/mikefarah/yq/releases/download/v4.44.2/yq_linux_amd64; chmod +x yq_linux_amd64
# yq() {
#   docker run --rm -i -v ${PWD}:/workdir mikefarah/yq yq $@
# }

cat sp.yaml | yq r - .



fw ctl set int cloud_balancer_port 0
fw ctl set int cloud_balancer_port 8117


$CPDIR/bin/cprid_util -server 108.143.208.96 -verbose rexec -rcmd /bin/bash -c  "cat /etc/fw/tmp/lb-health.sh"


mkdir www
hostname -i > www/index.html
cd www; python3 -m http.server 8081
 
 
for i in $(seq 10); do  curl  -k http://20.238.208.132 -m1 -s;  done | sort | uniq -c

CPMAN=$(az vm list-ip-addresses  -o json | jq -r '.[] | select(.virtualMachine.name == "cpman") | .virtualMachine.network.publicIpAddresses[0].ipAddress')
echo "CPMAN IP: $CPMAN"
ssh admin@$CPMAN

api status
mgmt_cli -r true show simple-gateways limit 50 offset 0 details-level "standard"  --format json

mgmt_cli -r true show simple-gateways limit 50 offset 0 details-level "full"  --format json | jq -r '.objects[]| [.name,."ipv4-address"]|@csv'

GWNAMES=$(mgmt_cli -r true show simple-gateways limit 50 offset 0 details-level "full"  --format json | jq -r '.objects[]| .name'); echo $GWNAMES

GWIPS=$(mgmt_cli -r true show simple-gateways limit 50 offset 0 details-level "full"  --format json | jq -r '.objects[]| ."ipv4-address"'); echo $GWIPS

GWIPS1=$(mgmt_cli -r true show simple-gateways limit 50 offset 0 details-level "full"  --format json | jq -r '.objects[]|select(.name|contains("VMSS1"))  | ."ipv4-address"'); echo $GWIPS1

GWIPS2=$(mgmt_cli -r true show simple-gateways limit 50 offset 0 details-level "full"  --format json | jq -r '.objects[]|select(.name|contains("VMSS2"))| ."ipv4-address"'); echo $GWIPS2

# OK
$CPDIR/bin/cprid_util -server 20.224.38.132 -verbose rexec -rcmd /bin/bash -c  "hostname -i"
#NOK
$CPDIR/bin/cprid_util -server ctrl--vmss1_4--58-VMSS1 -verbose rexec -rcmd /bin/bash -c  "hostname -i"

for i in $(echo $GWIPS | tr ' ' '\n'); do echo $i; $CPDIR/bin/cprid_util -server $i -verbose rexec -rcmd /bin/bash -c  "mkdir /home/admin/www;hostname -i>/home/admin/www/index.html; cat /home/admin/www/index.html"; done


for i in $(echo $GWIPS | tr ' ' '\n'); do echo $i; $CPDIR/bin/cprid_util -server $i -verbose rexec -rcmd /bin/bash -c  "cd /home/admin/www; python3 -m http.server 8081 &"; done

for i in $(echo $GWIPS1 | tr ' ' '\n'); do echo $i; $CPDIR/bin/cprid_util -server $i -verbose rexec -rcmd /bin/bash -c  "fw ctl set int cloud_balancer_port 0"; done

for i in $(echo $GWIPS1 | tr ' ' '\n'); do echo $i; $CPDIR/bin/cprid_util -server $i -verbose rexec -rcmd /bin/bash -c  "fw ctl set int cloud_balancer_port 8117"; done

for i in $(echo $GWIPS2 | tr ' ' '\n'); do echo $i; $CPDIR/bin/cprid_util -server $i -verbose rexec -rcmd /bin/bash -c  "fw ctl set int cloud_balancer_port 0"; done

for i in $(echo $GWIPS2 | tr ' ' '\n'); do echo $i; $CPDIR/bin/cprid_util -server $i -verbose rexec -rcmd /bin/bash -c  "fw ctl set int cloud_balancer_port 8117"; done


for i in $(echo $GWIPS | tr ' ' '\n'); do echo $i; curl_cli http://$i:8081 -s; done

# GLB
for i in $(seq 10); do  curl_cli  -k http://20.238.208.132 -m1 -s;  done | sort | uniq -c
while true; do echo; date; for i in $(seq 10); do  curl_cli  -k http://20.238.208.132 -m1 -s;  done | sort | uniq -c; done
# vmss1 NortEurupe
for i in $(seq 10); do  curl_cli  -k http://13.79.38.198 -m1 -s;  done | sort | uniq -c
# vmss2 WestEurope
for i in $(seq 10); do  curl_cli  -k http://108.143.45.211 -m1 -s;  done | sort | uniq -c
while true; do echo; date; for i in $(seq 10); do  curl_cli  -k http://13.80.16.223 -m1 -s;  done | sort | uniq -c; done
```