provider "aws" {
  region = "us-east-1"
}

resource "aws_spot_instance_request" "ec2_instance" {
  count         = length(var.components)
  ami           = data.aws_ami.devops_ami.id
  instance_type = "t2.micro"
  spot_type = "persistent"
  instance_interruption_behavior = "stop"
  wait_for_fulfillment = true
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  tags = {
    Name = element(var.components, count.index)
  }
}

data "aws_ami" "devops_ami" {
  most_recent      = true
  name_regex       = "^Centos"
  owners           = ["973714476881"]
}

resource "aws_ec2_tag" "ec2_tag" {
  count         = length(var.components)
  resource_id = element(aws_spot_instance_request.ec2_instance.*.spot_instance_id, count.index)
  key         = "Name"
  value       = element(var.components, count.index)
}

variable "components" {
  default = ["frontend", "catalogue", "cart", "shipping", "user", "payment", "mongodb", "mysql", "redis", "rabbitmq"]
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all_2"
  description = "Allow all traffic"
  vpc_id      = "vpc-0460de79"

  ingress = [
    {
      from_port        = 0
      to_port          = 65535
      description      = "allow incoming"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
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
    Name = "allow_all_2"
  }
}

resource "aws_route53_record" "route53_records" {
  count   = length(var.components)
  zone_id = "Z00216652JEVANUOGF0R3"
  name    = "${element(var.components, count.index)}-dev.knowaws.com"
  allow_overwrite = true
  type    = "A"
  ttl     = "300"
  records = [element(aws_spot_instance_request.ec2_instance.*.private_ip, count.index)]
}

terraform {
  backend "s3" {
    bucket = "tfstate-devopsvenu"
    key    = "tfstate/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "null_resource" "ansible" {
  depends_on = [aws_route53_record.route53_records]
  count      = length(var.components)
  provisioner "remote-exec" {
    connection {
      host     = element(aws_spot_instance_request.ec2_instance.*.private_ip, count.index)
      user     = "root"
      password = "DevOps321"
    }
    inline = [
      "sudo yum install python3-pip -y",
      "sudo pip3 install pip --upgrade",
      "sudo pip3 install ansible",
      "ansible-pull -U https://github.com/venuk-1502/devops.git ansible/roboshop/roboshop-pull.yml -e COMPONENT=${element(var.components, count.index)} -e ENV=dev"
    ]
  }
}