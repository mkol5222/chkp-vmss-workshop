up:
	terraform init; terraform apply -auto-approve

fwon:
	terraform apply -auto-approve -var route_through_firewall=true
fwoff:
	terraform apply -auto-approve -var route_through_firewall=false

down:
	terraform destroy -auto-approve