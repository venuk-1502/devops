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

resource "aws_route_table_association" "private_table_association" {
  count = length(aws_subnet.private-subnets.*.id)
  subnet_id      = element(aws_subnet.private-subnets.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "public_table_association" {
  count = length(aws_subnet.public-subnets.*.id)
  subnet_id      = element(aws_subnet.public-subnets.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}
