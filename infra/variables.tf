variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "The VPC ID to deploy into"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS tasks & RDS"
  type        = list(string)
}

variable "db_name" {
  description = "Postgres database name"
  type        = string
  default     = "deploymate"
}

variable "db_username" {
  description = "Postgres master username"
  type        = string
  default     = "parth"
}

variable "db_password" {
  description = "Postgres master password"
  type        = string
  sensitive   = true
  default     = "parth123"
}

variable "ecr_repo_name" {
  description = "Name of the ECR repository for the backend image"
  type        = string
  default     = "deploymate-backend"
}

variable "image_tag" {
  description = "Tag for the backend Docker image"
  type        = string
  default     = "latest"
}

output "alb_url" {
  description = "DNS name for your ALB"
  value       = aws_lb.alb.dns_name
  # or simply: value = aws_lb.alb.dns_name
}

variable "db_port" {
  description = "The port on which the RDS instance accepts connections"
  type        = number
  default     = 5432
}