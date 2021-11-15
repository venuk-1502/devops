resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id   = var.DEFAULT_VPC_ID
  vpc_id        = aws_vpc.vpc.id
  auto_accept   = true

  tags = {
    Name = "${var.ENV}-vpc-to-default-vpc-peering"
  }
}