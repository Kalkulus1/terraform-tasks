provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_acl" "aws_s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}


resource "aws_key_pair" "key" {
  key_name   = "servers_key"
  public_key = file("~/.ssh/servers.pub")
}

resource "aws_default_vpc" "default_vpc" {}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"

  # using default VPC
  vpc_id = aws_default_vpc.default_vpc.id

  ingress {
    description = "SSH from the Internet"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, tomap({ "Type" : "Allow SSH" }))
}


resource "aws_instance" "flugel_ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # reference to key
  key_name = aws_key_pair.key.key_name

  # reference to security group
  security_groups = [aws_security_group.allow_ssh.id]

  associate_public_ip_address = true

  tags = var.tags
}