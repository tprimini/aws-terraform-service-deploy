data "template_file" "task-def" {
    template = file("${path.module}/task_def.json")

    vars = {
        container_name   = var.container_name
        service_image    = "${data.aws_ecr_repository.service.repository_url}:simple-api"
        region           = var.region
        environment      = var.environment
        ecs_service_name = var.ecs_service_name
    }
}

resource "aws_ecs_task_definition" "ecs" {
    container_definitions    = data.template_file.task-def.rendered
    family                   = var.ecs_service_name
    cpu                      = 256
    memory                   = 512
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    execution_role_arn       = aws_iam_role.service.arn
    task_role_arn            = aws_iam_role.service.arn
}

resource "aws_alb_target_group" "service" {
    name        = "${var.environment}-${var.ecs_service_name}-tg"
    port        = 8443
    protocol    = "HTTPS"
    vpc_id      = data.aws_vpc.infra.id
    target_type = "ip"

    health_check {
        path                = "/simple-api/v1/health"
        protocol            = "HTTPS"
        matcher             = "200"
        interval            = 60
        timeout             = 30
        unhealthy_threshold = 3
    }

    tags = {
        Name = "${var.environment}-${var.ecs_service_name}-tg"
    }
}

resource "aws_ecs_service" "service" {
    name            = "${var.environment}-${var.ecs_service_name}-service"
    task_definition = aws_ecs_task_definition.ecs.arn
    desired_count   = 1
    cluster         = data.aws_ecs_cluster.infra.cluster_name
    launch_type     = "FARGATE"

    network_configuration {
        subnets          = data.aws_subnet_ids.infra.ids
        security_groups  = [ aws_security_group.service.id ]
        assign_public_ip = false
    }

    load_balancer {
        container_name   = var.ecs_service_name
        container_port   = 8443
        target_group_arn = aws_alb_target_group.service.arn
    }
}

resource "aws_alb_listener_rule" "service" {
    listener_arn = data.aws_lb_listener.alb_listener_https.arn
    action {
        type = "forward"
        target_group_arn = aws_alb_target_group.service.arn
    }

    condition {
        path_pattern  {
            values = ["/simple-api/v1*"]
        }
    }
}
