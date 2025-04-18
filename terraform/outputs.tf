output "lambda_function_name" {
  description = "The name of the deployed Lambda function"
  value       = aws_lambda_function.job_alert.function_name
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for deduplication"
  value       = aws_dynamodb_table.jobs.name
}

output "lambda_arn" {
  description = "Full ARN of the deployed Lambda function"
  value       = aws_lambda_function.job_alert.arn
}

output "region" {
  description = "The AWS region where resources are deployed"
  value       = var.aws_region
}

output "cloudwatch_schedule" {
  description = "The EventBridge schedule expression"
  value       = aws_cloudwatch_event_rule.three_hours_trigger.schedule_expression
}
