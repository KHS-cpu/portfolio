module "front-end" {
  source        = "./modules/front-end"
  bucket_name   = "khs-portfolio-website-bucket"
  domain_name   = "kaunghtetsan.tech"
  origin_name   = "portfolio_site_access"
  providers = {
    aws = aws.se  
  }

}



module "back-end" {
  source          = "./modules/back-end"
  dynamodb_name   = "visitor_count_2"
  hash_key        = "obj"
  region          = "ap-southeast-1"
  viewer_count    = "viewer_count"
  count_api       = "count_api_2"
   providers = {
    aws = aws.se  
  }
}


module "monitoring-alarms" {
  source          = "./modules/monitoring-alarms"
  lambda_function_name = module.back-end.lambda_function_name
   providers = {
    aws = aws.se  
  }
}

module "billing-alarms" {
  source          = "./modules/billing-alarms"
  providers = {
    aws = aws.useast  # Use the "useast" provider alias here for us-east-1
  }
}