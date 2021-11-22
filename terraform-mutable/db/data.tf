data "terraform_remote_state" "vpc" {
  backend = s3
  config = {
    bucket = "tfstate-devopsvenu"
    key    = "tfstate-mutable/vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_secretsmanager_secret" "by-name" {
  name = "roboshop"
}

data "aws_secretsmanager_secret_version" "secret_id" {
  secret_id = data.aws_secretsmanager_secret.by-name.id
}

output "example" {
  value = jsondecode(data.aws_secretsmanager_secret_version.secret_id.secret_string)["SSH_USER"]
}