# #Create the sns topic for AWS/Billing us-east-1
# resource "aws_sns_topic" "alerts_us" {
#   name = "alerts"
# }

# #Create sns topic subscription
# resource "aws_sns_topic_subscription" "sns_topic_subscription-us" {
#   topic_arn = aws_sns_topic.alerts_us.arn
#   protocol  = "https"
#   endpoint  = "https://events.pagerduty.com/integration/3b5db25446064001c02d6be7ac73cf05/enqueue"
# }

# #Create alarm for monthly budget alarm
# resource "aws_cloudwatch_metric_alarm" "monthly_budget_alarm" {
#   alarm_name                = "monthly_budget_alarm"
#   comparison_operator       = "GreaterThanOrEqualToThreshold"
#   evaluation_periods        = 1
#   metric_name               = "EstimatedCharges"
#   namespace                 = "AWS/Billing"
#   period                    = 21600 #Check once every 6 hours(Value shown in seconds)
#   statistic                 = "Maximum"
#   threshold                 = 2
#   alarm_description         = "Your billing amount is exceeding the threshold of 2$"
#   alarm_actions             = [aws_sns_topic.alerts_us.arn]
# }

