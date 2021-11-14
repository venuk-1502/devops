resource "aws_vpc" "vpc" {
  cidr_block = var.VPC_CIDR_MAIN

  tags = {
    Name = "${var.ENV}-vpc"
  }

}

resource "aws_vpc_ipv4_cidr_block_association" "vpc_cidr_association" {
  count = length(var.ADD_VPC_CIDR)
  cidr_block = element(var.ADD_VPC_CIDR, count.index)
  vpc_id     = aws_vpc.vpc.id
}
