# ecs.tf

################################################################################
# 1) ECR repo for the backend image
################################################################################
resource "aws_ecr_repository" "backend" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = { Name = var.ecr_repo_name }
}

################################################################################
# 2) ECS Cluster
################################################################################
resource "aws_ecs_cluster" "deploymate" {
  name = "deploymate-cluster"
}

################################################################################
# 3) SG for ECS tasks (only allow traffic from ALB → ECS)
################################################################################
resource "aws_security_group" "ecs" {
  name        = "deploymate-ecs-sg"
  description = "Allow ECS tasks to receive traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "deploymate-ecs-sg" }
}

################################################################################
# 4) ECS Task Definition
################################################################################
resource "aws_ecs_task_definition" "backend" {
  family                   = "deploymate-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${aws_ecr_repository.backend.repository_url}:${var.image_tag}"
      essential = true

      portMappings = [
        { containerPort = 8080, hostPort = 8080, protocol = "tcp" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.deploymate.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "backend"
      } }

      environment = [
        { name = "SPRING_DATASOURCE_URL", value = "jdbc:postgresql://${aws_db_instance.deploymate.address}:${aws_db_instance.deploymate.port}/${var.db_name}" },
        { name = "SPRING_DATASOURCE_USERNAME", value = var.db_username },
        { name = "SPRING_DATASOURCE_PASSWORD", value = var.db_password }
      ]
    }
  ])
}

################################################################################
# 5) ECS Service wired into the ALB → TG
################################################################################
resource "aws_ecs_service" "backend" {
  name            = "deploymate-service"
  cluster         = aws_ecs_cluster.deploymate.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.http]
}
