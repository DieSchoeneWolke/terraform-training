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




