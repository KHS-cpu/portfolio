resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "cloudfront-oac"
  description                       = "OAC to access s3 bucket static site"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [ aws_acm_certificate_validation.ssl_validation ]
  origin {
    domain_name              = aws_s3_bucket.static-website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = var.origin_name
  }


  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

  }

  price_class = "PriceClass_All"
  aliases = [var.domain_name, "www.${var.domain_name}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method = "sni-only"
    # cloudfront_default_certificate = true
  }
}