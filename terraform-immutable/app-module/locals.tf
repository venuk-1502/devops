locals {
  ssh_user = jsondecode(data.aws_secretsmanager_secret_version.secret_id.secret_string)["SSH_USER"]
  ssh_pass = jsondecode(data.aws_secretsmanager_secret_version.secret_id.secret_string)["SSH_PASS"]
  DEFAULT_VPC_CIDR = split(",", data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR)
  ALL_CIDR = concat(data.terraform_remote_state.vpc.outputs.VPC_CIDR_ALL, local.DEFAULT_VPC_CIDR)
}
