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
  description = "IAM policy for Lambda to access DynamoDB, SES, and CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["dynamodb:GetItem", "dynamodb:PutItem"],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action   = ["ses:SendEmail"],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attach_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}