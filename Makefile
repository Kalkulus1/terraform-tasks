include .env
export $(shell sed 's/=.*//' .env)

terraform-init:
	terraform init

terraform-plan:
	terraform fmt && \
	terraform validate && \
	terraform plan

terraform-apply:
	terraform apply

terraform-destroy:
	terraform destroy