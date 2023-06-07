#terraform {
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "~> 4.16"
#    }
#  }

#  required_version = ">= 1.2.0"
#}

# Even though it's not required, it's highly recommended to include the terraform block in your main.tf file for better consistency, reliability, and compatibility.
# I leave it commented out know since I don't know the required versions for the used modules so terraform will use the latest version available

provider "aws" {
  region = "eu-central-1"
}

# Your resources and configurations go here