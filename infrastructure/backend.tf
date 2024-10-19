terraform {
  backend "s3" {
    bucket = "chaban-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "test-dynamo-db"
  }
}