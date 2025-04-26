# Subnet group for RDS
resource "aws_db_subnet_group" "deploymate" {
  name       = "${var.db_name}-subnets"
  subnet_ids = var.private_subnet_ids

  tags = { Name = "${var.db_name}-subnets" }
}

# SG for RDS (Postgres)
resource "aws_security_group" "rds" {
  name        = "${var.db_name}-rds-sg"
  description = "Allow Postgres access within VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.db_name}-rds-sg" }
}

# The RDS instance itself
resource "aws_db_instance" "deploymate" {
  identifier          = "${var.db_name}-db"
  engine              = "postgres"
  engine_version      = "15"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
  publicly_accessible = false

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.deploymate.name

  tags = { Name = "${var.db_name}-db" }
}
