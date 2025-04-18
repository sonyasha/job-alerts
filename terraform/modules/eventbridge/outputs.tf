output "schedule_expression" {
  description = "The EventBridge schedule expression"
  value       = aws_cloudwatch_event_rule.three_hours_trigger.schedule_expression
}
