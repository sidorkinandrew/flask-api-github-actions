resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "flask-api-key-pair"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${pathexpand("~/.ssh/${aws_key_pair.key_pair.key_name}.pem")}"
  content  = tls_private_key.key_pair.private_key_pem
  file_permission = "400"
}