resource "aws_internet_gateway" "flask_api_igw" {
  tags = {
    Name = "${var.tag_name}igw"
  }

  vpc_id = aws_vpc.flask_api_vpc.id
}
