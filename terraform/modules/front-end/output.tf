output "name_servers" {
    value = aws_route53_zone.primary.name_servers
}

output "CF_domain" {
    value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "bucket_name" {
    value = aws_s3_bucket.static-website.id
}