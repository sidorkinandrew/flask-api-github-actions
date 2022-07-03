resource "aws_launch_template" "flask_api_lt" {
  default_version = "1"
  image_id        = var.ami_id
  instance_type   = "t2.micro"
  key_name        = var.aws_key_name
  name            = "${var.tag_name}lt"

  network_interfaces {
    device_index       = "0"
    ipv4_address_count = "0"
    ipv4_prefix_count  = "0"
    network_card_index = "0"
    security_groups    = [aws_security_group.flask_api_lt_web_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.tag_name}lt"
    }
  }
}
