# RDS PostgreSQL
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
# Free Tier: db.t3.micro, 750 hrs/month, 20GB SSD (first year)

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "${var.project_name}-postgres"

  engine         = "postgres"
  engine_version = "17"
  instance_class = var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 20 # No autoscaling to stay within Free Tier
  storage_type          = "gp2"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  multi_az = false # Single AZ (Free Tier)

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  skip_final_snapshot      = true
  delete_automated_backups = true
  deletion_protection      = false

  tags = {
    Name = "${var.project_name}-postgres"
  }
}
