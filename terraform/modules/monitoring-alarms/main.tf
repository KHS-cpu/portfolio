#Create the sns topic
resource "aws_sns_topic" "alerts" {
  name = "alerts"
}

#Create sns topic subscription
resource "aws_sns_topic_subscription" "sns_topic_subscription" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "https"
  endpoint  = "https://events.pagerduty.com/integration/3b5db25446064001c02d6be7ac73cf05/enqueue"
}

#Create alarm for Lambda Function alarm
resource "aws_cloudwatch_metric_alarm" "lambda_function_alarm" {
  alarm_name                = "lambda_function_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "EstimatedCharges"
  namespace                 = "AWS/Lambda"
  period                    = 3600 #Check once every 1 hour(Value shown in seconds)
  statistic                 = "Sum"
  threshold                 = 1
  alarm_description         = "Your lambda function is having errors"
  dimensions = {
    FunctionName = var.lambda_function_name
  }
  alarm_actions             = [aws_sns_topic.alerts.arn]
}