resource "aws_cloudwatch_event_rule" "three_hours_trigger" {
  name                = "job_alert_three_hours_trigger"
  schedule_expression = var.schedule_expr
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.three_hours_trigger.name
  target_id = "lambda"
  arn       = var.lambda_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.three_hours_trigger.arn
}
