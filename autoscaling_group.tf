resource "aws_autoscaling_group" "flask_api_asg" {
  vpc_zone_identifier       = [aws_subnet.flask_api_subnet_public_01.id, aws_subnet.flask_api_subnet_public_02.id]
  desired_capacity          = "1"
  force_delete              = "false"
  health_check_grace_period = "300"
  health_check_type         = "EC2"

  launch_template {
    id      = aws_launch_template.flask_api_lt.id
    version = "$Latest"
  }

  max_instance_lifetime = "0"
  max_size              = "2"
  min_size              = "1"
  name                  = "${var.tag_name}asg"
  protect_from_scale_in = "true"

  tag {
    key                 = "Name"
    propagate_at_launch = "true"
    value               = "${var.tag_name}asg"
  }

  target_group_arns = [aws_lb_target_group.flask_api_tg.id]
}
