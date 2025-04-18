variable "lambda_arn" {
  description = "ARN of the Lambda function to trigger"
  type        = string
}

variable "lambda_name" {
  description = "Name of the Lambda function to trigger"
  type        = string
}

variable "schedule_expr" {
  description = "The EventBridge schedule expression"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the EventBridge rule"
  type        = map(string)
}
