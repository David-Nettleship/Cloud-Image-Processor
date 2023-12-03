terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }

  backend "s3" {
    bucket         = "dn-terraform-state-304707804854"
    key            = "Cloud-Image-Processor/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "dn-terraform-state-lock-304707804854"
  }
}
