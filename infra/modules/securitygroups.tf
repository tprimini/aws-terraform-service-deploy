resource "aws_security_group" "infra-alb" {
  name = "${var.environment}-${var.region}-${var.ecs_cluster_name}-alb-sg"
  vpc_id = aws_vpc.infra.id

  ingress {
    from_port = 443
    protocol = "TCP"
    to_port = 443
    cidr_blocks = [var.internet_cidr_blocks]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [var.internet_cidr_blocks]
  }
}