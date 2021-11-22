locals {
  VPC_CIDR_MAIN = split(",", var.VPC_CIDR_MAIN)
  VPC_CIDR_ALL  = concat(local.VPC_CIDR_MAIN, var.ADD_VPC_CIDR)

}