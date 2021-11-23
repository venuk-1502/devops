resource "aws_lb_target_group" "tg" {
  name     = "${var.COMPONENT}-${var.ENV}"
  port     = var.PORT
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
}

resource "aws_lb_target_group_attachment" "tg" {
  count = length(local.INSTANCE_IDS)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(local.INSTANCE_IDS, count.index)
  port             = var.PORT
}

resource "aws_lb_listener_rule" "private-listener-rule" {
  count        = var.IS_PRIVATE ? 1 : 0
  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority     = var.PRIORITY

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.knowaws.com"]
    }
  }
}

resource "aws_lb_listener" "publiclb" {
  count             = var.IS_PRIVATE ? 0 : 1
  load_balancer_arn = data.terraform_remote_state.alb.outputs.PUBLIC_ALB_ARN
  port              = var.PORT
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}