terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

provider "aws" {
  # Configuration options
}

# provider "aws" {
#   region = "us-east-1"
#   alias = "useast"
# }

# provider "aws" {
#   region = "ap-southeast-1"
#   alias = "se"
# }
