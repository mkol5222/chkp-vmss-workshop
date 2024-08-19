#!/bin/bash

# Create a new SSH key pair
(cd ~/.ssh && ssh-keygen -t rsa -b 2048 -f 58-ssh -N "")
# check
ls -l ~/.ssh/58-ssh*

# cpman ip
CPMAN_IP=$(az vm list-ip-addresses  -o json | jq -r '.[] | select(.virtualMachine.name == "cpman") | .virtualMachine.network.publicIpAddresses[0].ipAddress')
echo "cpman_ip: $CPMAN_IP"

# login to cpman API
U=admin
P='Welcome@Home#1984'

# POST https://<mgmt-server>:<port>/web_api/login
mgmt_server="https://$CPMAN_IP"

# POST {{server}}/login
# Content-Type: application/json

# {
#   "user" : "aa",
#   "password" : "aaaa"
# }

# login

sid=$(curl -ks -X POST $mgmt_server/web_api/login -H 'Content-Type: application/json' -d "{\"user\":\"$U\",\"password\":\"$P\"}" | jq -r .sid)
echo "sid: $sid"
if [ "$sid" == "null" ]; then
  echo "Failed to login to Management API. Try again later."
  exit 1
fi

if [ "$sid" == "" ]; then
  echo "Failed to login to Management API. Try again later."
  exit 1
fi
# run script
# POST {{server}}/run-script
# Content-Type: application/json
# X-chkp-sid: {{session}}

# {
#   "script-name" : "Script Example: List files under / dir",
#   "script-type" : "one time",
#   "script" : "ls -l /",
#   "targets" : [ "corporate-gateway" ]
# }

# run script
PUBKEY=$(cat ~/.ssh/58-ssh.pub)

script64=$(cat  << EOF | base64 -w0
rm -rf /home/admin/.ssh
mkdir -p /home/admin/.ssh
echo "$PUBKEY" > /home/admin/.ssh/authorized_keys
chmod u=rwx,g=,o=  /home/admin/.ssh
chmod u=rwx,g=,o=  /home/admin/.ssh/authorized_keys 
cat /home/admin/.ssh/authorized_keys
id
cd ~; pwd
EOF
)

echo
echo "$script64"
echo 

res=$(curl -ks -X POST $mgmt_server/web_api/run-script -H "Content-Type: application/json" -H "X-chkp-sid: $sid" -d "{\"script-name\":\"Script\",\"script-type\":\"one time\",\"script-base64\":\"$script64\",\"targets\":[\"cpman\"]}")
echo "$res"
taskid=$(echo "$res" | jq -r '.tasks[0]."task-id"')
echo "taskid: $taskid"

# get task


# POST {{server}}/show-task
# Content-Type: application/json
# X-chkp-sid: {{session}}

# {
#   "task-id" : "2eec70e5-78a8-4bdb-9a76-cfb5601d0bcb"
# }

# get task
echo 'wait for 15 seconds'
sleep 15

res=$(curl -ks -X POST $mgmt_server/web_api/show-task -H "Content-Type: application/json" -H "X-chkp-sid: $sid" -d "{\"task-id\":\"$taskid\",\"details-level\":\"full\"}")
# echo "$res" | jq .

echo "$res" | jq -r '.tasks[0]."task-details"[0].responseMessage' | base64 -d

#### 

# cd; cd .ssh
# cat > ~/.ssh/authorized_keys
# chmod u=rwx,g=,o=  ~/.ssh
# chmod u=rwx,g=,o=  ~/.ssh/authorized_keys 

echo "Login to cpman"
echo "ssh -i ~/.ssh/58-ssh admin@$CPMAN_IP"

ssh -i ~/.ssh/58-ssh admin@$CPMAN_IP