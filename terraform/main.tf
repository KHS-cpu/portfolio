module "front-end" {
  source        = "./modules/front-end"
  bucket_name   = "khs-portfolio-website-bucket"
  domain_name   = "kaunghtetsan.tech"
  origin_name   = "portfolio_site_access"

}



module "back-end" {
  source          = "./modules/back-end"
  dynamodb_name   = "visitor_count_2"
  hash_key        = "obj"
  region          = "ap-southeast-1"
  viewer_count    = "viewer_count"
  count_api       = "count_api_2"
}