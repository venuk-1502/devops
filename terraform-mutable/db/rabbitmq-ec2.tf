resource "aws_spot_instance_request" "rabbitmq" {
  ami           = data.aws_ami.devops_ami.id
  instance_type = var.RABBITMQ_INSTANCE_TYPE
  spot_type = "persistent"
  instance_interruption_behavior = "stop"
  wait_for_fulfillment = true
  vpc_security_group_ids = [aws_security_group.rabbitmq.id]
  subnet_id = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS[0]
  tags = {
    Name = "rabbitmq-${var.ENV}"
  }
}

resource "aws_ec2_tag" "rabbitmq" {
  resource_id = aws_spot_instance_request.rabbitmq.spot_instance_id
  key         = "Name"
  value       = "rabbitmq-${var.ENV}"
}

resource "aws_security_group" "rabbitmq" {
  name        = "rabbitmq_sg_${var.ENV}"
  description = "rabbitmq_sg_${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
    {
      name             = "rabbitmq"
      from_port        = 5672
      to_port          = 5672
      description      = "rabbitmq port"
      protocol         = "tcp"
      cidr_blocks      = local.ALL_CIDR
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      name             = "SSH"
      from_port        = 22
      to_port          = 22
      description      = "SSH PORT"
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
    Name = "rabbitmq_sg_${var.ENV}"
  }
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTEDZONE_ID
  name    = "rabbitmq-${var.ENV}.knowaws.com"
  allow_overwrite = true
  type    = "A"
  ttl     = "300"
  records = aws_spot_instance_request.rabbitmq.private_ip
}


resource "null_resource" "rabbitmq" {
  depends_on = [aws_route53_record.rabbitmq]
  provisioner "remote-exec" {
    connection {
      host     = aws_spot_instance_request.rabbitmq.private_ip
      user     = local.ssh_user
      password = local.ssh_pass
    }
    inline = [
      "sudo yum install python3-pip -y",
      "sudo pip3 install pip --upgrade",
      "sudo pip3 install ansible",
      "ansible-pull -U https://github.com/venuk-1502/devops.git ansible/roboshop/roboshop-pull.yml -e COMPONENT=rabbitmq -e ENV=${var.ENV}"
    ]
  }
}