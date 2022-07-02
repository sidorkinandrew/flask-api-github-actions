resource "aws_route_table" "flask_api_rtable_public" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.flask_api_igw.id
  }

  tags = {
    Name = "${var.tag_name}public_rt"
  }

  vpc_id = aws_vpc.flask_api_vpc.id
}


resource "aws_route_table" "flask_api_rtable_private" {

  tags = {
    Name = "${var.tag_name}private_rt"
  }

  vpc_id = aws_vpc.flask_api_vpc.id
}
