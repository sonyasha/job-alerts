terraform {
  backend "s3" {
    bucket         = "my-tf-job-alerts-state-unique-bucket-2025"
    key            = "job-alerts/terraform/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam"
  tags   = var.tags
}

module "dynamodb" {
  source = "./modules/dynamodb"
  tags   = var.tags
}

module "lambda" {
  source          = "./modules/lambda"
  lambda_role_arn = module.iam.lambda_exec_role_arn
  dynamodb_table  = module.dynamodb.dynamodb_table_name
  sender_email    = var.sender_email
  recipient_email = var.recipient_email
  search_query    = var.search_query
  google_api_key  = var.google_api_key
  cse_id          = var.cse_id
  tags            = var.tags
}

module "eventbridge" {
  source        = "./modules/eventbridge"
  lambda_arn    = module.lambda.lambda_arn
  lambda_name   = module.lambda.lambda_name
  schedule_expr = "rate(3 hours)"
  tags          = var.tags
}