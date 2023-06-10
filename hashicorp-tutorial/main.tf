// This is a single-line comment
/*
multi-line 
comment
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

/*
Even though it's not required, it's highly recommended to include the terraform block in your main.tf file for better consistency, reliability, and compatibility.
*/

provider "aws" {
  region = "eu-central-1"
}

// Your resources and configurations go here

resource "aws_instance" "app_server" {
  ami           = "ami-04e601abe3e1a910f"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}

#terraform init
#terraform apply -var "instance_name=YOURNAME"
#terraform destroy

#when launched it will rename your instance