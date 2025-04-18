output "lambda_function_name" {
  description = "The name of the deployed Lambda function"
  value       = module.lambda.lambda_name
}

output "lambda_arn" {
  description = "Full ARN of the deployed Lambda function"
  value       = module.lambda.lambda_arn
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for deduplication"
  value       = module.dynamodb.dynamodb_table_name
}

output "cloudwatch_schedule" {
  description = "The EventBridge schedule expression"
  value       = module.eventbridge.schedule_expression
}

output "region" {
  description = "The AWS region where resources are deployed"
  value       = var.aws_region
}