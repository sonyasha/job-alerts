variable "aws_region" {
  description = "The AWS region where resources will be deployed"
  default     = "us-west-1"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "JobAlerts"
    Environment = "production"
    Terraform   = "true"
  }
}

variable "sender_email" {
  description = "Email address to send alerts from"
  type        = string
}

variable "recipient_email" {
  description = "Email address to send alerts to"
  type        = string
}

variable "search_query" {
  description = "Search query string for Google CSE"
  type        = string
}

variable "google_api_key" {
  description = "Google Custom Search API key"
  type        = string
}

variable "cse_id" {
  description = "Google Custom Search Engine ID"
  type        = string
}