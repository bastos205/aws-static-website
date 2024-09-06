# create a managed certificate for the static website
resource "aws_acm_certificate" "static_website" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "Static Website Certificate"
  }
}

data "aws_route53_zone" "static_website" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "static_website" {
  for_each = {
    for dvo in aws_acm_certificate.static_website.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      type    = dvo.resource_record_type
      value   = dvo.resource_record_value
      zone_id = data.aws_route53_zone.static_website.zone_id
    }
  }
  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  zone_id         = each.value.zone_id
  records         = [each.value.value]
  ttl             = 60
}

resource "aws_acm_certificate_validation" "static_website" {
  certificate_arn         = aws_acm_certificate.static_website.arn
  validation_record_fqdns = [for record in aws_route53_record.static_website : record.fqdn]
}

# create an origin access control for S3
resource "aws_cloudfront_origin_access_control" "static_website" {
  name                              = "static_website"
  description                       = "Origin Access Identity for the static website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# create a cloudfront distribution for the static website
resource "aws_cloudfront_distribution" "static_website" {
  origin {
    domain_name = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.static_website.bucket_regional_domain_name

    origin_access_control_id = aws_cloudfront_origin_access_control.static_website.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "A static website distribution"
  default_root_object = "index.html"

  aliases = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.static_website.bucket_regional_domain_name

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.static_website.arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    Name = "A static website distribution"
  }
}

# create a route53 record for the cloudfront distribution
resource "aws_route53_record" "static_website_cloudfront" {
  zone_id = data.aws_route53_zone.static_website.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.static_website.domain_name
    zone_id                = aws_cloudfront_distribution.static_website.hosted_zone_id
    evaluate_target_health = false
  }
}