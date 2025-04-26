terraform {
  backend "s3" {
    bucket         = "deploymate-tfstate"
    key            = "deploymate/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "deploymate-tf-locks"
    encrypt        = true
  }
}
