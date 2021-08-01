resource "aws_iam_role" "service" {
    name               = "${var.environment}-${var.ecs_service_name}-iam-role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
            },
            "Action": "sts:AssumeRole"
        }
    ]    
}
EOF
}

resource "aws_iam_role_policy" "service" {
    name   = "${var.environment}-${var.ecs_service_name}-iam-role-policy"
    role   = aws_iam_role.service.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:*",
                "ecr:*",
                "logs:*",
                "cloudwatch:*",
                "elasticloadbalancing:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_security_group" "service" {
    name = "${var.environment}-${var.ecs_service_name}-sg"
    vpc_id = data.aws_vpc.infra.id

    ingress {
        from_port = 8443
        protocol = "tcp"
        to_port = 8443
        cidr_blocks = [ data.aws_vpc.infra.cidr_block ]
    }

    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "${var.environment}-${var.ecs_service_name}-sg"
    }
}