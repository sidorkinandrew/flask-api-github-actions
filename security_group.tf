resource "aws_security_group" "flask_api_alb_sg" {
  description = "allow 80 inbound"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  name   = "${var.tag_name}alb-sg"
  vpc_id = aws_vpc.flask_api_vpc.id

}

resource "aws_security_group" "flask_api_db_sg" {
  description = "SG for RDS"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port       = "3306"
    protocol        = "tcp"
    security_groups = [aws_security_group.flask_api_lt_web_sg.id]
    self            = "false"
    to_port         = "3306"
  }

  name   = "${var.tag_name}db"
  vpc_id = aws_vpc.flask_api_vpc.id
}

resource "aws_security_group" "flask_api_lt_web_sg" {
  description = "allow 8080 / and my ssh"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    from_port       = "8080"
    protocol        = "tcp"
    security_groups = [aws_security_group.flask_api_alb_sg.id]
    self            = "false"
    to_port         = "8080"
  }

  name   = "${var.tag_name}_lt_web_sg"
  vpc_id = aws_vpc.flask_api_vpc.id
}

