resource "aws_subnet" "flask_api_subnet_public_01" {
  cidr_block                                  = "172.16.0.0/24"
  enable_resource_name_dns_a_record_on_launch = "true"
  map_public_ip_on_launch                     = "true"
  private_dns_hostname_type_on_launch         = "ip-name"

  tags = {
    Name = "${var.tag_name}public_01"
  }

  vpc_id = aws_vpc.flask_api_vpc.id
}


resource "aws_subnet" "flask_api_subnet_private_01" {
  cidr_block                                  = "172.16.2.0/24"
  enable_resource_name_dns_a_record_on_launch = "false"
  map_public_ip_on_launch                     = "false"
  private_dns_hostname_type_on_launch         = "ip-name"

  tags = {
    Name = "${var.tag_name}private_01"
  }

  vpc_id = aws_vpc.flask_api_vpc.id
}

resource "aws_subnet" "flask_api_subnet_public_02" {
  cidr_block                                  = "172.16.1.0/24"
  enable_resource_name_dns_a_record_on_launch = "true"
  map_public_ip_on_launch                     = "true"
  private_dns_hostname_type_on_launch         = "ip-name"

  tags = {
    Name = "${var.tag_name}public_02"
  }

  vpc_id = aws_vpc.flask_api_vpc.id
}

resource "aws_subnet" "flask_api_subnet_private_02" {
  cidr_block                                  = "172.16.3.0/24"
  enable_resource_name_dns_a_record_on_launch = "false"
  map_public_ip_on_launch                     = "false"
  private_dns_hostname_type_on_launch         = "ip-name"

  tags = {
    Name = "${var.tag_name}private_02"
  }

  vpc_id = aws_vpc.flask_api_vpc.id
}
