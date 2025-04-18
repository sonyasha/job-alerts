variable "bucket_name" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for state locking"
  type        = string
}

variable "tags" {
  description = "Tags to apply to backend setup resources"
  type        = map(string)
}