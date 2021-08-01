variable "region" {
    type = string
    default = "us-east-1"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "ecs_cluster_name" {
    type = string
    default = "infra"
}

variable "remote_state_key" {
    type = string
    default = "tf_infra_state"
}

variable "remote_state_bucket" {
    type = string
    default = "dev-org-001-infra-tf-state"
}

variable "container_name" {
    type = string
    default = "simple-api"
}

variable "service_name" {
    type = string
    default = "simple-api"
}

variable "service_image" {
    type = string
    default = "simple-api"
}

variable "log_level" {
    type = string
    default = "debug"
}

variable "ecs_service_name" {
    type = string
    default = "simple-api"
}

variable "min_capacity" {
    type = number
    default = 1
}

variable "max_capacity" {
    type = number
    default = 5
}