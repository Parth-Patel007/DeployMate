aws_region     = "us-east-1"
aws_account_id = "493742263077"

# VPC & networking
vpc_id = "vpc-03001fa10d92ad197"
public_subnet_ids = [
  "subnet-09178fcd904e1d68f",
  "subnet-04452da175c256747",
]
private_subnet_ids = [
  "subnet-0c17c03cb155d8a19",
  "subnet-0a43a10ac74edafc0",
]

# RDS Postgres you already created
db_endpoint = "deploymate-db.c8tmyskykv6b.us-east-1.rds.amazonaws.com:5432"
db_port     = 5432
db_username = "parth"
db_password = "parth123"

# Which Docker tag to deploy
image_tag = "latest"
