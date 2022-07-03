data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

output "my_ip" {
  value = "${chomp(data.http.myip.body)}/32"
}

output "main_vpc_id" {
  value = aws_vpc.flask_api_vpc.id
}

output "aws_subnets" {
  value = [
    aws_subnet.flask_api_subnet_public_01.id,
    aws_subnet.flask_api_subnet_public_02.id,
    aws_subnet.flask_api_subnet_private_01.id,
    aws_subnet.flask_api_subnet_private_02.id
  ]
}