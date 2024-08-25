terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.1"
    }
  }
}
provider "vault" {
  address = "http://3.106.54.97:8200"
}

# Fetch the AWS credentials from Vault
data "vault_generic_secret" "aws_creds" {
  path = "secrets/creds/ritish"
}

# Set up the AWS provider using the credentials fetched from Vault
provider "aws" {
  region     = "ap-southeast-2"
  access_key = data.vault_generic_secret.aws_creds.data["username"]
  secret_key = data.vault_generic_secret.aws_creds.data["password"]
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" : "Demo-VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "Demo-VPC-Subnet-2a"
  }
}

resource "aws_route_table" "test" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "a" {
  route_table_id = aws_route_table.test.id
  subnet_id      = aws_subnet.main.id
}

resource "aws_instance" "test" {
  ami                         = "ami-01fb4de0e9f8f22a7"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main.id
  key_name                    = "reddy"
  security_groups             = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "tf-example"
  }
}

resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.example.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
