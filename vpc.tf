resource "aws_vpc" "flask_api_vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "${var.tag_name}vpc"
  }

  tags_all = {
    Name = "${var.tag_name}vpc"
  }
}
