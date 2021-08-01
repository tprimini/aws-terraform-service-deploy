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

variable "domain" {
    type = string
    default = "yourdomain.com"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "azs" {
    default = ["a", "b"]
}

variable "internet_cidr_blocks" {
    default = "0.0.0.0/0"
}