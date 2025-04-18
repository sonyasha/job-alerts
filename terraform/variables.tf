variable "sender_email" {}
variable "recipient_email" {}
variable "search_query" {}
variable "google_api_key" {}
variable "cse_id" {}
variable "aws_region" {
  default = "us-west-1"
}
variable "tags" {
  type = map(string)
  default = {
    Project     = "JobAlerts"
    Environment = "production"
    Terraform   = "true"
  }
}