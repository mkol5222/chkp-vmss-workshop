#!/bin/bash

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
# echo "sid: $sid"
if [ "$sid" == "null" ]; then
  echo "Failed to login to Management API. Try again later."
  exit 1
fi

if [ "$sid" == "" ]; then
  echo "Failed to login to Management API. Try again later."
  exit 1
fi

### https://app.swaggerhub.com/apis-docs/Check-Point/cme-api/v1.2#/Management/get_management

# Request: PUT https://127.1.2.3/web_api/cme-api/v1.2/management
# Headers: Content-Type: application/json, X-chkp-sid: 111111
# Body: {"name" : "my_MGMT"}

RESPUTMGMT=$(curl -ks -X PUT $mgmt_server/web_api/cme-api/v1.2/management \
  -H "Content-Type: application/json" \
  -H "X-chkp-sid: $sid" \
  -d "{\"name\":\"mgmt\"}" | jq -r '."status-code"')
echo "RESPUTMGMT: $RESPUTMGMT"

if [ "$RESPUTMGMT" != "200" ]; then
  echo "Failed to create CME management server. Try again later."
  exit 1
fi

# get (read-only) credentials to list VMSS in Azure 
CLIENT_ID=$(cat ./reader.json | jq -r .client_id)
CLIENT_SECRET=$(cat ./reader.json | jq -r .client_secret)
TENANT_ID=$(cat ./reader.json | jq -r .tenant_id)
SUBSCRIPTION_ID=$(cat ./reader.json | jq -r .subscription_id)

BODY=$(echo '{"name" : "my_account", "subscription" : "123456", "application_id" : "7891011", "directory_id" : "12131415", "client_secret" : "16171819"}' \
    | jq -c --arg S "$SUBSCRIPTION_ID"\
       --arg U "$CLIENT_ID" \
       --arg P "$CLIENT_SECRET" \
       --arg T "$TENANT_ID" \
        ' .subscription=$S| ."application_id"=$U | ."directory_id"=$T | ."client_secret"=$P |.')

curl -ks -X POST $mgmt_server/web_api/cme-api/v1.2/accounts/azure \
  -H "Content-Type: application/json" \
  -H "X-chkp-sid: $sid" \
  -d "$BODY" | jq .
# Request: POST https://127.1.2.3/web_api/cme-api/v1.2/accounts/azure
# Headers: Content-Type: application/json, X-chkp-sid: 111111
# Body: {"name" : "my_account", "subscription" : "123456", "application_id" : "7891011", "directory_id" : "12131415", "client_secret" : "16171819"}
# Response: {"status-code" : 200, "result" : { }, "error" : { }}

# Request: POST https://127.1.2.3/web_api/cme-api/v1.2/gwConfigurations/azure
# Headers: Content-Type: application/json, X-chkp-sid: 111111
# Body: {"name" : "azure_gw_configuration", "base64_sic_key" : "Base64SIC", "version" : "R81.20", "policy" : "Standard", "related_account" : "my_account"}
# d2VsY29tZWhvbWUxOTg0 vs MTIzNDU2Nzg=
TEMPLATE_BODY=$(echo '{"name" : "vmss_template", "blades": { "ips": true, "identity-awareness": true}, "base64_sic_key" : "d2VsY29tZWhvbWUxOTg0=", "version" : "R81.20", "policy" : "Azure", "related_account" : "my_account"}' ) #\
    #| jq -c --arg S "$(echo welcomehome1984|base64)" '.base64_sic_key=$S | .' )

echo "$TEMPLATE_BODY" | jq .

curl -ks -X DELETE $mgmt_server/web_api/cme-api/v1.2/gwConfigurations/vmss_template \
  -H "Content-Type: application/json" \
  -H "X-chkp-sid: $sid" 
  

curl -ks -X POST $mgmt_server/web_api/cme-api/v1.2/gwConfigurations/azure \
  -H "Content-Type: application/json" \
  -H "X-chkp-sid: $sid" \
  -d "$TEMPLATE_BODY"

echo
echo 
echo "Done."
echo "You can now login to the management server at $CPMAN_IP using make ssh-cpman"
echo "   and try: "
echo "      autoprov_cfg show all ; tail -f /opt/CPcme/log/cme.log"