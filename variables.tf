variable "environment" {
  description = "Environment (dev, stage, prod)"
  type        = string
}

variable "regions" {
  type        = list(string)
  description = "List of regions for the environment"
}


variable "cidr_block" {
  description = "range of Ips"
  type        = list(string)
}

##variable "private_subnets" {
##type    = list(string)

##}



#resource "azurerm_virtual_network" "vnet-name" {
#name = "${var.vnet-name}${var.env}"