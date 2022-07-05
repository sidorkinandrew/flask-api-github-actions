resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "-_"
}

resource "aws_db_instance" "flask_api_db" {
  allocated_storage                     = "10"
  auto_minor_version_upgrade            = "false"
  availability_zone                     = "${var.aws_region}a"
  backup_retention_period               = "0"
  skip_final_snapshot                   = "true"
  db_name                               = "student"
  db_subnet_group_name                  = aws_db_subnet_group.flask_api_db_subnet_group.name
  deletion_protection                   = "false"
  engine                                = "mysql"
  engine_version                        = "8.0.28"
  iam_database_authentication_enabled   = "false"
  identifier                            = "flask-db"
  instance_class                        = "db.t3.micro"
  iops                                  = "0"
  license_model                         = "general-public-license"
  max_allocated_storage                 = "0"
  monitoring_interval                   = "0"
  multi_az                              = "false"
  option_group_name                     = "default:mysql-8-0"
  parameter_group_name                  = "default.mysql8.0"
  performance_insights_enabled          = "false"
  performance_insights_retention_period = "0"
  port                                  = "3306"
  publicly_accessible                   = "false"
  storage_encrypted                     = "false"
  storage_type                          = "gp2"
  username                              = "user"
  password                              = random_password.password.result
  vpc_security_group_ids                = [aws_security_group.flask_api_db_sg.id]
}
