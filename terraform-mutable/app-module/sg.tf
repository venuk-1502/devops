resource "aws_security_group" "sg" {
  name        = "${var.COMPONENT}-${var.ENV}"
  description = "${var.COMPONENT}-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
    {
      from_port        = var.PORT
      to_port          = var.PORT
      description      = "http traffic"
      protocol         = "tcp"
      cidr_blocks      = data.terraform_remote_state.vpc.outputs.VPC_CIDR_ALL
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      from_port        = 22
      to_port          = 22
      description      = "ssh traffic"
      protocol         = "tcp"
      cidr_blocks      = local.ALL_CIDR
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      description      = "allow outgoing"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }
}
