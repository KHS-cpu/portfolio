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

# Region for Billing alarm
provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
}

#Create the sns topic for AWS/Billing us-east-1
resource "aws_sns_topic" "alerts_us" {
  name = "alerts"
  provider = aws.us-east-1
}

#Create sns topic subscription
resource "aws_sns_topic_subscription" "sns_topic_subscription-us" {
  topic_arn = aws_sns_topic.alerts_us.arn
  provider = aws.us-east-1
  protocol  = "https"
  endpoint  = "https://events.pagerduty.com/integration/3b5db25446064001c02d6be7ac73cf05/enqueue"
}

#Create alarm for monthly budget alarm
resource "aws_cloudwatch_metric_alarm" "monthly_budget_alarm" {
  alarm_name                = "monthly_budget_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "EstimatedCharges"
  namespace                 = "AWS/Billing"
  period                    = 21600 #Check once every 6 hours(Value shown in seconds)
  statistic                 = "Maximum"
  threshold                 = 2
  alarm_description         = "Your billing amount is exceeding the threshold of 2$"
  alarm_actions             = [aws_sns_topic.alerts_us.arn]
  provider                  = aws.us-east-1
  dimensions = {
    Currency = "USD"
  }

  treat_missing_data = "notBreaching"
}

