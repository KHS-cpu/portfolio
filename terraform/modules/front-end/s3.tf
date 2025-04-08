resource "aws_s3_bucket" "static-website" {
  bucket = var.bucket_name
  force_destroy = true
}

#This option ensures that the bucket owner has full control over the object, regardless of who uploaded it. 
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.static-website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#This is to block all the public access for the bucket
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.static-website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#Use OAC policy and give bucket policy for cloudfront
resource "aws_s3_bucket_policy" "oac_policy" {
  bucket = aws_s3_bucket.static-website.id
  policy = jsonencode({
    Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service: "cloudfront.amazonaws.com"
                }
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.static-website.arn}/*"
                Condition = {
                    StringEquals = {
                        "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
                    }
                }
            }
        ]
  })
}


#Enable object versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.static-website.id
  versioning_configuration {
    status = "Enabled"
  }
}

