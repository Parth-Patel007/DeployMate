output "backend_ecr_url" {
  description = "ECR repository URL for backend"
  value       = aws_ecr_repository.backend.repository_url
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.deploymate.name
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.alb.dns_name
}

output "backend_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.backend.name
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.deploymate.endpoint
}

output "db_port" {
  description = "RDS port"
  value       = aws_db_instance.deploymate.port
}

output "backend_tg_arn" {
  description = "ARN of the DeployMate backend ALB target‐group"
  value       = aws_lb_target_group.backend.arn
}

output "alb_arn" {
  description = "ARN of the DeployMate ALB"
  value       = aws_lb.alb.arn
}