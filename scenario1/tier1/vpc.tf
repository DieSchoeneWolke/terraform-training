terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.1.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "presentationtier-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.31.1.0/27"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "presentationtier-subnet-a"
  }
}

resource "aws_subnet" "apptier-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.31.2.0/27"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "apptier-subnet-a"
  }
}

resource "aws_subnet" "datatier-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.31.3.0/27"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "datatier-subnet-a"
  }
}

resource "aws_subnet" "datatier-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.31.4.0/27"
  availability_zone = "eu-central-1b"
  tags = {
    Name = "datatier-subnet-b"
  }
}

/*
Elastic IP
resource "aws_eip" "vpc" {
  domain   = "vpc"
}

// I created it through the AWS console so it wouldn't get removed with 'terraform destroy' and to keep the ID for the nat gateway.
*/


resource "aws_nat_gateway" "main" {
  allocation_id = "eipalloc-0ef6edfdf95dc3118"
  subnet_id = "subnet-01f9fdadcf7afc51f"
  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  # depends_on = [aws_internet_gateway.example]

}