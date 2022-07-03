resource "aws_lb_target_group" "flask_api_tg" {
  deregistration_delay = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "2"
    interval            = "5"
    matcher             = "200"
    path                = "/api/health-check/ok"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "3"
    unhealthy_threshold = "2"
  }

  name             = "flask-api-tg"
  port             = "80"
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  slow_start       = "0"

  tags = {
    Name = "${var.tag_name}tg"
  }

  tags_all = {
    Name = "${var.tag_name}tg"
  }

  target_type = "instance"
  vpc_id      = aws_vpc.flask_api_vpc.id
}
