resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route  = [
    {
      cidr_block                   = var.DEFAULT_VPC_CIDR
      vpc_peering_connection_id    = aws_vpc_peering_connection.peering.id
      carrier_gateway_id           = ""
      "destination_prefix_list_id" = ""
      "egress_only_gateway_id"     = ""
      "gateway_id"                 = ""
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
    Name = "private_route_table"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route  = [
    {
      cidr_block                   = var.DEFAULT_VPC_CIDR
      vpc_peering_connection_id    = aws_vpc_peering_connection.peering.id
      carrier_gateway_id           = ""
      "destination_prefix_list_id" = ""
      "egress_only_gateway_id"     = ""
      "gateway_id"                 = ""
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

#
#resource "aws_route" "route" {
#  route_table_id            = "rtb-4fbb3ac4"
#  destination_cidr_block    = "10.0.1.0/22"
#  vpc_peering_connection_id = "pcx-45ff3dc1"
#  depends_on                = [aws_route_table.testing]
#}