resource "aws_vpc" "vpc" {
  cidr_block = var.VPC_CIDR_MAIN

  tags = {
    Name = "${var.ENV}-vpc"
  }

}



