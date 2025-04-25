# 1. Grab your default VPC (so you don't have to hard-code its ID)
data "aws_vpc" "default" {
  default = true
}

# 2. Pull in *all* subnets in that VPC
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 3. Create an RDS Subnet Group out of those subnets
resource "aws_db_subnet_group" "deploymate" {
  name       = "deploymate-subnets"
  subnet_ids = data.aws_subnets.all.ids

  tags = {
    Name = "deploymate-subnets"
  }
}

# 4. Stand up a security group that only allows Postgres in from your VPC
resource "aws_security_group" "rds" {
  name        = "deploymate-rds-sg"
  description = "Allow Postgres access from within the VPC"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 5. Finally, the RDS instance itself
resource "aws_db_instance" "deploymate" {
  identifier              = "deploymate-db"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  # ← Here’s the fix: use db_name (not name)
  db_name                 = var.db_name

  username                = var.db_username
  password                = var.db_password

  db_subnet_group_name    = aws_db_subnet_group.deploymate.name
  vpc_security_group_ids  = [aws_security_group.rds.id]

  skip_final_snapshot     = true
  publicly_accessible     = false
}
