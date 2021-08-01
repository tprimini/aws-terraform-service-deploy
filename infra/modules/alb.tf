# ALB ##################################################################################################################

resource "aws_alb" "infra" {
  name            = "${var.environment}-${var.region}-${var.ecs_cluster_name}-alb"
  internal        = false // it is true when we use it to private networks
  security_groups = [aws_security_group.infra-alb.id]
  subnets         = aws_subnet.public.*.id // it needs at least 2 subnets
  tags = {
    Name = "${var.environment}-${var.region}-infra-alb"
  }
}

resource "aws_alb_listener" "default" {
  load_balancer_arn = aws_alb.infra.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" // default
  certificate_arn   = aws_acm_certificate.domain.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html><h2>default response from infra</a></h2></html>"
      status_code  = 200
    }
  }
}
