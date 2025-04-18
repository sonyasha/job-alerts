resource "aws_lambda_function" "job_alert" {
  function_name    = "job_alert_lambda"
  role             = var.lambda_role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  filename         = "../lambda_function.zip"
  source_code_hash = filebase64sha256("../lambda_function.zip")
  environment {
    variables = {
      DYNAMODB_TABLE  = var.dynamodb_table
      SENDER_EMAIL    = var.sender_email
      RECIPIENT_EMAIL = var.recipient_email
      SEARCH_QUERY    = var.search_query
      GOOGLE_API_KEY  = var.google_api_key
      CSE_ID          = var.cse_id
    }
  }
  tags = var.tags
}