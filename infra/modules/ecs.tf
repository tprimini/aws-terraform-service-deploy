# ECS Cluster ##########################################################################################################

resource "aws_ecs_cluster" "infra" {
  name = "${var.environment}-${var.region}-${var.ecs_cluster_name}"
  setting {
    name = "containerInsights" // metrics from cloudwatch
    value = "enabled"
  }
}

resource "aws_iam_role" "infra" {
  name = "${var.ecs_cluster_name}-iam-role"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
 {
   "Effect": "Allow",
   "Principal": {
     "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com", "application-autoscaling.amazonaws.com"]
   },
   "Action": "sts:AssumeRole"
  }
  ]
 }
EOF
}

resource "aws_iam_role_policy" "infra" {
  name = "${var.ecs_cluster_name}-iam-role"
  role = aws_iam_role.infra.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "ecr:*",
        "dynamodb:*",
        "cloudwatch:*",
        "s3:*",
        "rds:*",
        "sqs:*",
        "sns:*",
        "logs:*",
        "ssm:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}