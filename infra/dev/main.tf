terraform {
    backend "s3" {
        bucket = "dev-org-001-infra-tf-state"
        key    = "tf_infra_state"
        region = "us-east-1"
    }
}

module "cluster" {
    source = "../modules/"
    region = var.region
    environment = var.environment
    azs = var.azs
    vpc_cidr = var.vpc_cidr
    ecs_cluster_name = var.ecs_cluster_name
    internet_cidr_blocks = var.internet_cidr_blocks
    domain = var.domain
}
