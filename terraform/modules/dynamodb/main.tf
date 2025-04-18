resource "aws_dynamodb_table" "jobs" {
  name         = "job_alerts_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
  tags = var.tags
}