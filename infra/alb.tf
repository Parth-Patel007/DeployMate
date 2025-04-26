# Security Group for the ALB
resource "aws_security_group" "alb" {
  name        = "deploymate-alb-sg"
  description = "Allow inbound HTTP to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "deploymate-alb-sg" }
}

# The Application Load Balancer
resource "aws_lb" "alb" {
  name               = "deploymate-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb.id]

  tags = { Name = "deploymate-alb" }
}

# Target Group for your Spring Boot backend
resource "aws_lb_target_group" "backend" {
  name     = "deploymate-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"
  health_check {
    path                = "/healthz"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = { Name = "deploymate-tg" }
}

# HTTP listener on port 80 → TG
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}
