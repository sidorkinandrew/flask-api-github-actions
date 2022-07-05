data "aws_availability_zones" "available" {}

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

output "aws_azs" {
  value = data.aws_availability_zones.available.names
}

data "aws_instances" "launched_by_asg" {
  instance_tags = {
    "aws:autoscaling:groupName" = "flask_api_asg"
  }

  instance_state_names = ["running"]
}

output "ec2_launched_ids" {
  value = data.aws_instances.launched_by_asg.ids
}

output "ec2_launched_ips" {
  value = data.aws_instances.launched_by_asg.public_ips
}

output "alb_dns_name" {
  value = aws_lb.flask_api_alb.dns_name
}

output "rds_mysql_instance_endpoint" {
  value = aws_db_instance.flask_api_db.endpoint
}

output "rds_db_password" {
  value     = random_password.password.result
  sensitive = true
}