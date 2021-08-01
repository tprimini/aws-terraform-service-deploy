data "aws_vpc" "infra" {
    filter {
        name   = "tag:Name"
        values = [ "${var.environment}-${var.region}-infra" ]
    }
}

data "aws_subnet_ids" "infra" {
    vpc_id = data.aws_vpc.infra.id

    tags = {
        Tier = "private"
    }
}

data "aws_ecs_cluster" "infra" {
    cluster_name = "${var.environment}-${var.region}-${var.ecs_cluster_name}"
}

data "aws_lb" "infra" {
    name = "${var.environment}-${var.region}-${var.ecs_cluster_name}-alb"
}

data "aws_lb_listener" "alb_listener_https" {
    load_balancer_arn = data.aws_lb.infra.arn
    port              = 443
}