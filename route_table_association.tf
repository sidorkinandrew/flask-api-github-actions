resource "aws_route_table_association" "associate_public_01" {
  route_table_id = aws_route_table.flask_api_rtable_public.id
  subnet_id      = aws_subnet.flask_api_subnet_public_01.id
}

resource "aws_route_table_association" "associate_public_02" {
  route_table_id = aws_route_table.flask_api_rtable_public.id
  subnet_id      = aws_subnet.flask_api_subnet_public_02.id
}

resource "aws_route_table_association" "associate_private_01" {
  route_table_id = aws_route_table.flask_api_rtable_private.id
  subnet_id      = aws_subnet.flask_api_subnet_private_01.id
}

resource "aws_route_table_association" "associate_private_02" {
  route_table_id = aws_route_table.flask_api_rtable_private.id
  subnet_id      = aws_subnet.flask_api_subnet_private_02.id
}