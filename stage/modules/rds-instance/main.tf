resource "aws_db_instance" "myapp-db" {
  identifier = var.cluster_identifier
  engine = var.engine_type
  engine_version = var.engine_version
  instance_class = var.db_instance_class
  allocated_storage = var.allocated_storage
  username = "admin"
  password = "dbadmin"
  db_name = var.rds_db_name
  skip_final_snapshot = true

  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name = "myapp-db"
  }
}