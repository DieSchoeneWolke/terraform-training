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

//Elastic IP

resource "aws_eip" "vpc" {
  domain   = "vpc"
}

// I created it through the AWS console so it wouldn't get removed with 'terraform destroy' and to keep the ID for the nat gateway.
// Update: Enabled it again beacuse using an elastic IP incurs some costs when it's not attached! 
// $0.005 per Elastic IP address not attached to a running instance per hour

resource "aws_nat_gateway" "main_ngw" {
  allocation_id = "eipalloc-094f3c5ef0a632d99"
  subnet_id = aws_subnet.presentationtier-a.id
  tags = {
    Name = "main"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main_igw]

}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main_ngw.id
}

resource "aws_route_table_association" "presentationtier_a_association" {
  subnet_id      = aws_subnet.presentationtier-a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "apptier_a_association" {
  subnet_id      = aws_subnet.apptier-a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "datatier_a_association" {
  subnet_id      = aws_subnet.datatier-a.id
  route_table_id = aws_route_table.private_rt.id
}
