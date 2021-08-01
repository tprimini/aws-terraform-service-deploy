variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "remote_state_key" {
  type = string
}

variable "remote_state_bucket" {
  type = string
}

variable "container_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "log_level" {
  type = string
}

variable "service_image" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "min_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}