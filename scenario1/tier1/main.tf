// This is a single-line comment
/*
multi-line 
comment
*/

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.1.0"
    }
  }
}

/*
Even though it's not required, it's highly recommended to include the terraform block in your main.tf file for better consistency, reliability, and compatibility.
*/

provider "aws" {
  region = "eu-central-1"
}

// Your resources and configurations go here

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/28"
  availability_zone = eu-central-1a
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "appserver" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/28"
  availability_zone = eu-central-1a
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_subnet" "db" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/28"
  availability_zone = eu-central-1a
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.2.0.0/28"
  availability_zone = eu-central-1a
  tags = {
    Name = "private-subnet"
  }
}

/*
Make VPC
~~● 4 subnets (1 public, 3 private)~~

● Enable in subnet settings public ip addresses
● Make it highly available (use 2 availability zones, the final private subnet can be the only
one in a different subnet)

● Allocate an Elastic IP
● Create a nat gateway
● Create an internet gateway and attach it to your VPC
● Make route tables for your public and private subnets and attach an internet gateway
and nat gateway to them respectively
● Make security groups for Bastion Host, web server, app server, and database
● Make sure to go back to security groups after making them and adding security groups
to link them together, for example in the app server security group adding a rule for the
database security group after creating the database security group.
*/


/*
current work: step 2 & 3
*/