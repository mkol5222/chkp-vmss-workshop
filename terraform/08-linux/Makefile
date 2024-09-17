up:
	terraform init; terraform apply -auto-approve

fwon:
	terraform apply -auto-approve -var route_through_firewall=true

haon:
	terraform apply -auto-approve -var route_through_firewall=true -var nexthop="10.1.2.105"

fwoff:
	terraform apply -auto-approve -var route_through_firewall=false

down:
	terraform destroy -auto-approve
ssh:
	( ./ssh-linux.sh; ssh -o "StrictHostKeyChecking no" linux)