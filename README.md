# terraform-tasks
Tasks

## Install Terraform
```sh
#! /bin/bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" -y
sudo apt-get update && sudo apt-get install terraform -y
echo "Terraform Installed Successfully!"
terraform -v
```

or just run
```sh
chmod +x install_terraform.sh
./install_terraform.sh
```

### Generate ssh keys

```sh
cd ~/.ssh
ssh-keygen
```
You can name it as `servers`

### .env file

```sh
cp .env.example .env
```

### Update the .env files
```sh
TF_VAR_aws_region="us-east-1"
TF_VAR_aws_access_key="your access key"
TF_VAR_aws_secret_key="your secret key"
TF_VAR_bucket_name="your bucket name"
TF_VAR_force_destroy="your boolean value"
```

### Running makefile

Run the init
```sh
make terraform-init
```

Run the plan
```sh
make terraform-plan
```

Run apply changes
```sh
make terraform-apply
```

Destroy changes
```sh
make terraform-destroy
```

### Running with terraform commands without using Makefile

Copy `terraform.tfvars.example` to `terraform.tfvars`
```sh
cp terraform.tfvars.example terraform.tfvars
```

Run terraform commands

```sh
terraform init
terraform fmt
terraform validate
terraform apply
terraform destroy
```