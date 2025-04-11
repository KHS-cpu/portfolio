variable "dynamodb_name" {
  description = "This is the name of the dynamoDB"
  type = string
}

variable "hash_key" {
  description = "This is the value for hash-key"
  type = string
}

variable "region" {
  description = "This is the region"
  type = string
}

variable "viewer_count" {
  description = "This is the lambda function name"
  type = string
}

variable "count_api" {
  description = "This is the REST api name"
  type = string
}