resource "aws_subnet" "private-subnets" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.vpc_cidr_association]
  count = length(var.PRIVATE_SUBNETS)
  cidr_block = element(var.PRIVATE_SUBNETS, count.index)
  vpc_id     = aws_vpc.vpc.id
  availability_zone = element(var.AZS, count.index)
  tags = {
    Name = "private-sub-${var.ENV}-${count.index}"
  }
}

resource "aws_subnet" "public-subnets" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.vpc_cidr_association]
  count = length(var.PUBLIC_SUBNETS)
  cidr_block = element(var.PUBLIC_SUBNETS, count.index)
  vpc_id     = aws_vpc.vpc.id
  availability_zone = element(var.AZS, count.index)
  tags = {
    Name = "public-sub-${var.ENV}-${count.index}"
  }
}

