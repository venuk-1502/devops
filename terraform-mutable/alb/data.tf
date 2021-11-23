data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tfstate-devopsvenu"
    key    = "tfstate-mutable/vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

