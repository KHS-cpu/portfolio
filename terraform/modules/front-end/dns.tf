#Create hosted zone
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

# Region for ACM certificate
provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
}

#Request SSL Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  provider = aws.us-east-1
  subject_alternative_names = ["www.${var.domain_name}"]
  lifecycle {
    create_before_destroy = true
  }
}

#DNS Validation
resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}

#ACM Certificate validation
resource "aws_acm_certificate_validation" "ssl_validation" {
  provider = aws.us-east-1
  depends_on = [ aws_acm_certificate.cert, aws_route53_record.validation_record ]
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
}

#Create A record for domain from cloudfront to domain
resource "aws_route53_record" "cloudfront-a1-record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
  depends_on = [ aws_cloudfront_distribution.s3_distribution, aws_acm_certificate.cert ]
}

#Create A record for domain from cloudfront to domain
resource "aws_route53_record" "cloudfront-a2-record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
  depends_on = [ aws_cloudfront_distribution.s3_distribution, aws_acm_certificate.cert ]
}