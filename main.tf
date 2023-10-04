##resource "random_string" "naming" {
##special = false
##upper   = false
##length  = 7
#}

#locals {
# prefix = "dummy${random_string.naming.result}"
#}

##module "creating_workspaces" {
##source = "./creating_workspaces"
##}

##module "managing_workspaces" {
##source = "./managing_workspaces"
##}

data "aws_availability_zones" "available" {
 
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"


  name = "vpc-${var.environment}"
  #cidr = var.cidr_block[var.environment == "dev" || var.environment == "stage" ? 0 : index(var.regions, var.environment)]
  cidr = var.environment == "dev" || var.environment == "stage" ? element(var.cidr_block, 0) : element(var.cidr_block, index(var.regions, var.environment))



  azs = var.environment == "dev" || var.environment == "stage" ? local.dev_region : local.prod_region
  
  
  #flatten([
   # for idx, region in var.regions :
    #[
     # for az in data.aws_availability_zones.available[region].names :
      #var.environment == "dev" || var.environment == "stage" ? [
       # "${region}${az}a",
        #"${region}${az}b"
        #] : [
        #"${region}${az}a",
        #"${region}${az}b",
        #"${region}${az}c"
      #]
    #]
  #]#)

  
  private_subnets = var.environment == "dev" || var.environment == "stage" ? [cidrsubnet(element(var.cidr_block, 0), 3, 0), cidrsubnet(element(var.cidr_block, 0), 3, 1)] : [cidrsubnet(element(var.cidr_block, 0), 3, 3), cidrsubnet(element(var.cidr_block, 0), 3, 1), cidrsubnet(element(var.cidr_block, 0), 3, 2)]
 #azs = var.environment == "dev" ? local.dev_region : local.prod_region
  #private_subnets = var.environment == "dev" ? [cidrsubnet(var.cidr_block, 3, 0), cidrsubnet(var.cidr_block, 3, 1)] : [cidrsubnet(var.cidr_block, 3, 0), cidrsubnet(var.cidr_block, 3, 1), cidrsubnet(var.cidr_block, 3, 2)]
  #private_subnets = [cidrsubnet(var.cidr_block, 3, 0),cidrsubnet(var.cidr_block, 3, 1)]
  #private_subnet_tags = { tier = private }
  #public_subnets  = var.environment == "dev" ? [cidrsubnet(cidr, 3, 2), cidrsubnet(cidr, 3, 3)] : [cidrsubnet(cidr, 3, 3), cidrsubnet(cidr, 3, 4), cidrsubnet(cidr, 3, 5)]

  

  public_subnets = var.environment == "dev" || var.environment == "stage" ? [cidrsubnet(element(var.cidr_block, 0), 3, 2), cidrsubnet(element(var.cidr_block, 0), 3, 3)] : [cidrsubnet(element(var.cidr_block, 0), 3, 4), cidrsubnet(element(var.cidr_block, 0), 3, 5), cidrsubnet(element(var.cidr_block, 0), 3, 6)]


  #public_subnets = var.environment == "dev" || var.environment == "stage" ? [cidrsubnet(element(var.cidr_block,0), 3, 2), cidrsubnet(element(var.cidr_block,0), 3, 3)] : [cidrsubnet(var.cidr_block, 3, 4), cidrsubnet(var.cidr_block, 3, 5), cidrsubnet(var.cidr_block, 3, 6)]
  #public_subnet_tags  = { tier = public }

  enable_dns_support            = true
  enable_dns_hostnames          = true
  enable_nat_gateway            = true
  one_nat_gateway_per_az        = true
  create_igw                    = true
  manage_default_security_group = false


  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}