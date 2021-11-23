resource "aws_spot_instance_request" spot-instance {
  count = var.SPOT_INSTANCE_COUNT
  ami           = data.aws_ami.devops_ami.id
  instance_type = var.INSTANCE_TYPE
  spot_type = "persistent"
  instance_interruption_behavior = "stop"
  wait_for_fulfillment = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS, count.index)
  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }
}

resource "aws_ec2_tag" "ec2-tag" {
  count = length(var.SPOT_INSTANCE_COUNT)
  resource_id = element(aws_spot_instance_request.spot-instance.*.spot_instance_id, count.index)
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}"
}

resource "aws_instance" "od-instance" {
  count         = var.OD_INSTANCE_COUNT
  ami           = data.aws_ami.devops_ami.id
  instance_type = var.INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS, count.index)

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }
}

