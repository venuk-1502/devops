provider "aws" {
  region = "us-east-1"
}

resource "aws_spot_instance_request" "test" {
  ami           = "ami-0dc863062bc04e1de"
  instance_type = "t2.micro"
  wait_for_fulfillment = true

  tags = {
    Name = "my-instance"
  }
}

resource "aws_ec2_tag" "ec2_tag" {
  resource_id = aws_spot_instance_request.test.spot_instance_id
  key         = "Name"
  value       = "test1"
}