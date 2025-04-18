output "lambda_arn" {
  description = "Full ARN of the deployed Lambda function"
  value       = aws_lambda_function.job_alert.arn
}

output "lambda_name" {
  description = "Name of the deployed Lambda function"
  value       = aws_lambda_function.job_alert.function_name
}
