data "aws_ami" "devops_ami" {
  most_recent      = true
  name_regex       = "^Devops-AMI-Ansible"
  owners           = ["378784712135"]
}

data "aws_secretsmanager_secret" "by-name" {
  name = "roboshop-dev"
}

data "aws_secretsmanager_secret_version" "secret_id" {
  secret_id = data.aws_secretsmanager_secret.by-name.id
}