terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "hellocloud-aws-master-account"
    workspaces {
      name = "portfolio"
    }
  }
}