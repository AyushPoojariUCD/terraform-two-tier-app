# Terraform Block
# The `terraform` block is used to configure Terraform settings.
# Here, we declare the required providers and their versions.
# This ensures consistent builds by locking to specific provider versions.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"   # Official AWS provider maintained by HashiCorp
      version = "4.67.0"          # Lock provider version for stability
    }
  }
}

# AWS Provider Configuration
# The `provider` block tells Terraform how to connect to AWS.
# We configure the AWS provider to use the region passed in as a variable.
# Authentication details (like access key/secret key) can be:
#   - Set in environment variables (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY)
#   - Stored in ~/.aws/credentials
#   - Passed via shared config/profile

provider "aws" {
  region = var.region   # AWS region is parameterized via a variable
}
