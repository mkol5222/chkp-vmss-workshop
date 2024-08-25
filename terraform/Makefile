
welcome:
	echo "Welcome"


up:
	cd /workspaces/chkp-vmss-workshop/terraform; ./1stcleanyp.sh
	sp sa vmss1 reader cpman linux ha2vmss
sp:
	./00-azsp/create-az-sp.sh

sp-down:
	./00-azsp/delete-az-sp.sh

tfbackend:
	./00-tfbackend/up.sh
tfbackend-down:
	./00-tfbackend/down.sh

sa:
	./00-tfbackend/up.sh
sa-down:
	./00-tfbackend/down.sh


vmss1:
	(cd ./01-vmss-a && terraform init  -backend-config "storage_account_name=58tfbackend21745$$(cat ../sa-random.txt)" && terraform apply -auto-approve)

ha2vmss:
	(cd ./11-ha2vmss && terraform init  -backend-config "storage_account_name=58tfbackend21745$$(cat ../sa-random.txt)" && terraform apply -auto-approve)
ha2vmss-down:
	(cd ./11-ha2vmss && terraform destroy -auto-approve)


ha:
	(cd ./10-ha && terraform init  -backend-config "storage_account_name=58tfbackend21745$$(cat ../sa-random.txt)" && terraform apply -auto-approve)
ha-down:
	(cd ./10-ha && terraform destroy -auto-approve)

vmss1-down:
	(cd ./01-vmss-a && terraform destroy -auto-approve)

vmss2:
	(cd ./02-vmss-b && terraform init  -backend-config "storage_account_name=58tfbackend21745$$(cat ../sa-random.txt)" && terraform apply -auto-approve)

vmss2-down:
	(cd ./02-vmss-b && terraform destroy -auto-approve)

vmss-up: vmss1 vmss2
vmss-down: vmss1-down vmss2-down

reader:
	(cd ./03-reader && terraform init  -backend-config "storage_account_name=58tfbackend21745$$(cat ../sa-random.txt)" && terraform apply -auto-approve)

reader-down:
	(cd ./03-reader && terraform destroy -auto-approve)

cpman:
	(cd ./04-cpman && terraform init  -backend-config "storage_account_name=58tfbackend21745$$(cat ../sa-random.txt)" && terraform apply -auto-approve)

policy:
	./05-policy/policy_apply.sh

cpman-down:
	(cd ./04-cpman && terraform destroy -auto-approve)

cme:
	./06-cme/cme.sh
down: ha2vmss-down linux-down vmss1-down reader-down cpman-down tfbackend-down sp-down 

ssh:
	(cd ./07-ssh && ./setup-ssh.sh)

linux:
	(cd ./08-linux && make up)
linux-down:
	(cd ./08-linux && make down)

make ssh-linux:
	ssh linux


fwon:
	(cd ./08-linux && make fwon)
haon:
	(cd ./08-linux && make haon)
fwoff:
	(cd ./08-linux && make fwoff)
ssh-linux:
	(cd ./08-linux && make ssh)