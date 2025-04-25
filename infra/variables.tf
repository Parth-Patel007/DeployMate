variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "db_name" {
  description = "Name of the Postgres database to create"
  type        = string
  default     = "deploymate"
}

variable "db_username" {
  description = "Master username for the Postgres DB"
  type        = string
  default     = "parth"
}

variable "db_password" {
  description = "Master password for the Postgres DB"
  type        = string
  sensitive   = true
  default     = "parth123"
}
