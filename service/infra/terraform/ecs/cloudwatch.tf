resource "aws_cloudwatch_log_group" "service" {
  name = "${var.environment}-${var.region}-${var.ecs_service_name}"
}