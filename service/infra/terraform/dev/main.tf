terraform {
    backend "s3" {
        bucket = "dev-org-001-simple-api-tf-state"
        key    = "tf_simple-api_state"
        region = "us-east-1"
    }
}

module "ecs" {
    source = "../ecs/"
    region = var.region
    environment = var.environment
    ecs_cluster_name = var.ecs_cluster_name
    container_name = var.container_name
    ecs_service_name = var.ecs_service_name
    log_level = var.log_level
    remote_state_bucket = var.remote_state_bucket
    remote_state_key = var.remote_state_key
    service_image = var.service_image
    service_name = var.service_name
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
}