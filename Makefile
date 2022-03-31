include .env
export $(shell sed 's/=.*//' .env)

terraform-init:
	cd tasks && \
	terraform init && \
	cd ..

terraform-plan:
	cd tasks && \
	terraform fmt && \
	terraform validate && \
	terraform plan && \
	cd ..

terraform-apply:
	cd tasks && \
	terraform apply && \
	cd ..

terraform-destroy:
	cd tasks && \
	terraform destroy && \
	cd ..

go-tests:
	cd test && \
	go test -v && \
	cd ..