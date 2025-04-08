module "front-end" {
  source        = "./modules/front-end"
  bucket_name   = "khs-portfolio-website-bucket"
  domain_name   = "kaunghtetsan.tech"
  origin_name   = "portfolio_site_access"

}