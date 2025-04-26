# logging.tf
resource "aws_cloudwatch_log_group" "deploymate" {
  name              = "/ecs/deploymate"
  retention_in_days = 14
}
