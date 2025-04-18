output "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for deduplication"
  value       = aws_dynamodb_table.jobs.name
}