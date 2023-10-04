terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.16.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.64.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAWKTWSO4ODMRLUYXJ"
  secret_key = "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"
}

locals {
  dev_region = [
    "${element(var.regions, 0)}a",
    "${element(var.regions, 0)}b"
  ]

  prod_region = var.environment == "prod" ? flatten([
    for region in var.regions :
    [
      for az in data.aws_availability_zones.available[region].names : [
        "${region}${az}a",
        "${region}${az}b",
        "${region}${az}c"
      ]
    ]
  ]) : []
}




#locals {
# dev_region  = ["${element(var.region, 0)}a", "${element(var.region, 1)}b"]
#prod_region = ["${element(var.region, 0)}a", "${element(var.region, 1)}b", "${element(var.region, 2)}c"]
#}

# dev_azs  = ["${var.region}a ${var.region}b"]
# prod_azs = ["${var.region}a ${var.region}b ${var.region}c"]



// initialize provider in "MWS" mode to provision new workspace
provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  username   = var.databricks_account_username
  password   = var.databricks_account_password
  account_id = var.databricks_account_id
}