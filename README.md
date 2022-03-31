# terraform-tasks
Tasks

## Install Terraform
For debian based installation
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

`you will update the public key in the environment variables`

### .env file

```sh
cp .env.example .env
```

### Update the .env files
```sh
aws_region     = "us-east-1"
aws_access_key = "your access key"
aws_secret_key = "your secret key"
bucket_name=bucket-name
force_destroy=true
ami_id=ami-085925f297f89fce1
instance_type=t2.micro

TF_VAR_public_key=the-public-key-generated
```

`Update them based on your preference`

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
cp tasks/terraform.tfvars.example tasks/terraform.tfvars
```

Run terraform commands

```sh
cd tasks
terraform init
terraform fmt
terraform validate
terraform apply
terraform destroy
```


### Run go Tets
```sh
make go-tests
```