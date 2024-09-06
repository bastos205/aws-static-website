# Create SNS topic
resource "aws_sns_topic" "site_alert" {
  name = "site_offline_alert"
}

# Create SNS subscription
resource "aws_sns_topic_subscription" "alert_subscription" {
  topic_arn = aws_sns_topic.site_alert.arn
  protocol  = "email"
  endpoint  = var.sns_subscriber_email # Email address to receive alerts
}

# Create CloudWatch Alarm for CloudFront
resource "aws_cloudwatch_metric_alarm" "cdn_site_down" {
  alarm_name          = "CDNSiteOffline"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "5xxErrorRate" # Monitoring 5XX error rates on CloudFront
  namespace           = "AWS/CloudFront"
  period              = "3600"
  statistic           = "Average"
  threshold           = "1" # Alert if 5XX errors occur
  alarm_description   = "Alert when CloudFront distribution is returning 5XX errors"
  alarm_actions       = [aws_sns_topic.site_alert.arn]

  dimensions = {
    DistributionId = aws_cloudfront_distribution.static_website.id # Link the CloudFront distribution
  }
}

# Route53 Health Check for CloudFront CDN
resource "aws_route53_health_check" "cdn_health_check" {
  fqdn              = data.aws_route53_zone.static_website.name
  type              = "HTTP"
  failure_threshold = 3
  request_interval  = 30
  port              = 80
}