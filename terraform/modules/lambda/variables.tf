variable "sender_email" {
  description = "Email address to send alerts from"
  type        = string
}

variable "recipient_email" {
  description = "Email address to send alerts to"
  type        = string
}

variable "search_query" {
  description = "Google CSE search query string"
  type        = string
}

variable "google_api_key" {
  description = "Google API key for Custom Search"
  type        = string
}

variable "cse_id" {
  description = "Google Custom Search Engine ID"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for the Lambda function"
  type        = string
}

variable "dynamodb_table" {
  description = "Name of the DynamoDB table for deduplication"
  type        = string
}

variable "tags" {
  description = "Tags to apply to Lambda function"
  type        = map(string)
}