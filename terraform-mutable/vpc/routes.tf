resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route  = [
    {
      cidr_block                   = var.DEFAULT_VPC_CIDR
      vpc_peering_connection_id    = aws_vpc_peering_connection.peering.id
#      carrier_gateway_id           = ""
#      "destination_prefix_list_id" = ""
#      "egress_only_gateway_id"     = ""
#      "gateway_id"                 = ""
#      "instance_id"                = ""
#      "ipv6_cidr_block"            = ""
#      "local_gateway_id"           = ""
#      "nat_gateway_id"             = ""
#      "network_interface_id"       = ""
#      "transit_gateway_id"         = ""
#      "vpc_endpoint_id"            = ""
    },
    {
      cidr_block                   = "0.0.0.0/0"
      vpc_peering_connection_id    = ""
      carrier_gateway_id           = ""
      "destination_prefix_list_id" = ""
      "egress_only_gateway_id"     = ""
      "gateway_id"                 = ""
      "instance_id"                = ""
      "ipv6_cidr_block"            = ""
      "local_gateway_id"           = ""
      "nat_gateway_id"             = aws_nat_gateway.ngw.id
      "network_interface_id"       = ""
      "transit_gateway_id"         = ""
      "vpc_endpoint_id"            = ""
    }
  ]
  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route  = [
    {
      cidr_block                   = var.DEFAULT_VPC_CIDR
      vpc_peering_connection_id    = aws_vpc_peering_connection.peering.id
#      carrier_gateway_id           = ""
#      "destination_prefix_list_id" = ""
#      "egress_only_gateway_id"     = ""
#      "gateway_id"                 = ""
#      "instance_id"                = ""
#      "ipv6_cidr_block"            = ""
#      "local_gateway_id"           = ""
#      "nat_gateway_id"             = ""
#      "network_interface_id"       = ""
#      "transit_gateway_id"         = ""
#      "vpc_endpoint_id"            = ""
    },
    {
      cidr_block                   = "0.0.0.0/0"
      vpc_peering_connection_id    = ""
      carrier_gateway_id           = ""
      "destination_prefix_list_id" = ""
      "egress_only_gateway_id"     = ""
      "gateway_id"                 = aws_internet_gateway.igw.id
      "instance_id"                = ""
      "ipv6_cidr_block"            = ""
      "local_gateway_id"           = ""
      "nat_gateway_id"             = ""
      "network_interface_id"       = ""
      "transit_gateway_id"         = ""
      "vpc_endpoint_id"            = ""
    }
  ]
  tags = {
    Name = "public_route_table"
  }
}

data "aws_route_tables" "default-vpc-routes" {
  vpc_id = var.DEFAULT_VPC_ID
}

locals {
  VPC_CIDR_MAIN = split(",", var.VPC_CIDR_MAIN)
  VPC_CIDR_ALL  = concat(local.VPC_CIDR_MAIN, var.ADD_VPC_CIDR)
}

locals {
  association-list = flatten([
  for cidr in local.VPC_CIDR_ALL : [
    for route_table in tolist(data.aws_route_tables.default-vpc-routes.ids) : {
      cidr        = cidr
      route_table = route_table
  }
  ]
  ])
}

resource "aws_route" "route" {
  count = length(local.association-list)
  route_table_id            = tomap(element(local.association-list, count.index))["route_table"]
  destination_cidr_block    = tomap(element(local.association-list, count.index))["cidr"]
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}