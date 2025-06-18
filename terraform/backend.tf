# S3 + DynamoDB remote state configuration

terraform {
  backend "s3" {
    bucket = "harmony-tune-prod"
    key = "lambda-api/${terraform.workspace}/terraform.tfstate"
    region = "ap-northeast-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}