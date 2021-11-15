resource "aws_eip" "elastic-ip" {
  vpc      = true
  tags = {
    Name = "EIP-${var.ENV}"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.public-subnets.*.id[0]

  tags = {
    Name = "NGW-${var.ENV}"
  }

}