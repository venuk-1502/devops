provider "aws" {
  region = "us-east-1"
}

resource "aws_spot_instance_request" "test" {
  ami           = "ami-0dc863062bc04e1de"
  instance_type = "t2.micro"

  tags = {
    Name = "my-instance"
  }
}