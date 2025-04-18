provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
  tags = var.tags
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_job_alert_policy"
  description = "IAM policy for Lambda to access DynamoDB and SES"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["dynamodb:GetItem", "dynamodb:PutItem"],
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = ["ses:SendEmail"],
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attach_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

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

resource "aws_lambda_function" "job_alert" {
  function_name = "job_alert_lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  filename         = "../lambda_function.zip"
  source_code_hash = filebase64sha256("../lambda_function.zip")
  environment {
    variables = {
      DYNAMODB_TABLE   = aws_dynamodb_table.jobs.name
      SENDER_EMAIL     = var.sender_email
      RECIPIENT_EMAIL  = var.recipient_email
      SEARCH_QUERY     = var.search_query
      GOOGLE_API_KEY   = var.google_api_key
      CSE_ID           = var.cse_id
    }
  }
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "three_hours_trigger" {
  name                = "job_alert_three_hours_trigger"
  schedule_expression = "rate(3 hours)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.three_hours_trigger.name
  target_id = "lambda"
  arn       = aws_lambda_function.job_alert.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.job_alert.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.three_hours_trigger.arn
}