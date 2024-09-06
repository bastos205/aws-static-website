# Configure the Terraform backend
terraform {
  backend "s3" {
    bucket         = "b205p-terraform-state"
    key            = "b205/profile-static-website"
    region         = "us-east-1"
    dynamodb_table = "b205p-terraform-lock-state"
    encrypt        = true
    kms_key_id     = "alias/b205p-terraform-key"
  }
}