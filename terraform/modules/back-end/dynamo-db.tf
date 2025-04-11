resource "aws_dynamodb_table" "site-visitor-count" {
  name           = var.dynamodb_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.hash_key
  # range_key      = "views"
  attribute {
    name = "obj"
    type = "S"
  }

  # attribute {
  #   name = "views"
  #   type = "N"
  # }

}