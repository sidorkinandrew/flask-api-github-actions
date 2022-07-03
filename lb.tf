resource "aws_lb" "flask_api_alb" {
  internal           = "false"
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  name               = "flask-api-alb"
  security_groups    = [aws_security_group.flask_api_alb_sg.id]

  subnets = [aws_subnet.flask_api_subnet_public_01.id, aws_subnet.flask_api_subnet_public_02.id]

  tags = {
    Name = "${var.tag_name}alb"
  }

  tags_all = {
    Name = "${var.tag_name}alb"
  }
}
