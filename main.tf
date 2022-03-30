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
  key_name   = "servers_ssh_key"
  public_key = var.public_key
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
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  associate_public_ip_address = true

  tags = var.tags
}


# Task 2 starting...

# Create VPC
resource "aws_vpc" "flugel_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = var.tags
}


# Create Internet Gateway
resource "aws_internet_gateway" "flugel_igw" {
  vpc_id = aws_vpc.flugel_vpc.id

  tags = var.tags
}

# Create Route Table
resource "aws_route_table" "flugel_route_table" {
  vpc_id = aws_vpc.flugel_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.flugel_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.flugel_igw.id
  }

  tags = var.tags
}

# Create Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.flugel_vpc.id
  cidr_block = "10.0.${count.index + 1}.0/24"
  count      = 2

  tags = var.tags
}

# Associate subnet with Route Table
resource "aws_route_table_association" "route_association" {
  count          = 2
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index + 1)
  route_table_id = aws_route_table.flugel_route_table.id
}