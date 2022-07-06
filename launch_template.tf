resource "aws_launch_template" "flask_api_lt" {
  default_version = "1"
  image_id        = data.aws_ami.ubuntu-linux-2004.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.key_pair.key_name
  name            = "${var.tag_name}lt"

  network_interfaces {
    security_groups = [aws_security_group.flask_api_lt_web_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.tag_name}lt"
    }
  }
}
