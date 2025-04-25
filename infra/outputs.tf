output "db_endpoint" {
  description = "The address to connect to for Postgres"
  value       = aws_db_instance.deploymate.endpoint
}

output "db_port" {
  description = "The port Postgres is listening on"
  value       = aws_db_instance.deploymate.port
}
