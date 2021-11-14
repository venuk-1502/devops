resource "aws_subnet" "private-1" {
  count = length(var.PRIVATE_SUBNETS)
  cidr_block = element(var.PRIVATE_SUBNETS, count.index)
  vpc_id     = aws_vpc.vpc.id
  availability_zone = element(var.AZS, count.index)
  tags = {
    Name = "private-sub-${var.ENV}"
  }
}
