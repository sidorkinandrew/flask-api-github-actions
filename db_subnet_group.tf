resource "aws_db_subnet_group" "flask_api_db_subnet_group" {
  name       = "flask-api-subnet"
  subnet_ids = [aws_subnet.flask_api_subnet_private_01.id, aws_subnet.flask_api_subnet_private_02.id]
}
