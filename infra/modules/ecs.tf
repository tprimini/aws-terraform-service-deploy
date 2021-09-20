# ECS Cluster ##########################################################################################################

resource "aws_ecs_cluster" "infra" {
  name = "${var.environment}-${var.region}-${var.ecs_cluster_name}"
  setting {
    name = "containerInsights" // metrics from cloudwatch
    value = "enabled"
  }
}
