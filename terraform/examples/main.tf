provider "aws" {
  region = "us-east-1"
}

resource "aws_spot_instance_request" "test" {
  ami           = "ami-0dc863062bc04e1de"
  instance_type = "t2.micro"
  wait_for_fulfillment = true
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  tags = {
    Name = "my-instance"
  }
}

resource "aws_ec2_tag" "ec2_tag" {
  resource_id = aws_spot_instance_request.test.spot_instance_id
  key         = "Name"
  value       = "test1"
}


resource "aws_security_group" "allow_all" {
  name        = "allow_all_1"
  description = "Allow all traffic"
  vpc_id      = "vpc-0460de79"

  ingress = [
    {
      from_port        = 0
      to_port          = 0
      description      = "allow incoming"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
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
      self             = true
    }
  ]

  tags = {
    Name = "allow_all_1"
  }
}
