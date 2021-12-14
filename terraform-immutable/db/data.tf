data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tfstate-devopsvenu"
    key    = "tfstate-immutable/vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_secretsmanager_secret" "by-name" {
  name = "roboshop-${var.ENV}"
}

data "aws_secretsmanager_secret_version" "secret_id" {
  secret_id = data.aws_secretsmanager_secret.by-name.id
}

data "aws_ami" "devops_ami" {
  most_recent      = true
  name_regex       = "^Devops-AMI-Ansible"
  owners           = ["378784712135"]
}
