resource "aws_instance" "test" {
  ami           = "ami-0dc863062bc04e1de"
  instance_type = "t3.micro"

  tags = {
    Name = "my-instance"
  }
}
provider "aws" {
  region = "us-east-1"
}