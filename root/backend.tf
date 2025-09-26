# Terraform Remote Backend Configuration
# This block configures the remote backend to store Terraform state in S3.
# Using a remote backend is critical for team collaboration and preventing
# local state file loss. DynamoDB is used for state locking and consistency.

terraform {
  backend "s3" {
    # Name of the S3 bucket to store the Terraform state file
    bucket = "s3-bucket"

    # Path (key) inside the bucket where state will be stored
    key    = "backend/s3-bucket.tfstate"

    # AWS region where the S3 bucket and DynamoDB table exist
    region = "us-east-1"

    # DynamoDB table used for state locking to avoid concurrent operations
    dynamodb_table = "remote-backend"
  }
}
