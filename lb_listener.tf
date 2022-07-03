resource "aws_lb_listener" "flask_api_listener" {
  default_action {
    order            = "1"
    target_group_arn = aws_lb_target_group.flask_api_tg.id
    type             = "forward"
  }

  load_balancer_arn = aws_lb.flask_api_alb.id
  port              = "80"
  protocol          = "HTTP"
}
