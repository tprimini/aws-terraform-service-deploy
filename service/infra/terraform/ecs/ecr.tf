data "aws_ecr_repository" "service" {
  name = "${var.environment}-${var.region}-services"
}