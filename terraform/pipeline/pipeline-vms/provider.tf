terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "ade-prosperous-bucket-2024"
    key    = "pipeline/terraform.tfstate"
    region = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "prosperous-db"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.70.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region  = var.region
  profile = "default"
  default_tags {
    tags = {
      Name    = "pipeline_vms"
      project = "cicd_pipeline"
    }
  }
}