variable "app_lb_name" {
  type        = string
  description = "Name of the Load Balancer"
}

variable "target_gr_name" {
  type        = string
  description = "Name of the target group"
}

variable "lb_sg_name" {
  type        = string
  description = "name of the sg for lb"
}

variable "ecs_name" {
  type        = string
  description = "name of the ecs fargate cluster"
}

variable "domains_name" {
  type = list(string)
}

variable "vpc_id" {
  type        = string
  description = "id of the vpc that will be used to deploy lb and ecs cluster"
}

variable "app_name" {
  type        = string
  description = "name of the app that will run on ecs cluster"
}

variable "app_environment" {
  type        = string
  description = "environment in which we deploy the app"
}

variable "container_environment" {
  type        = string
  description = "environment of the containers"
}

variable "container_port" {
  type        = number
  description = "port of the container and of the host"
}

variable "container_image" {
  type        = string
  description = "name & tag of the image"
}

variable "lb_listener" {
  type        = number
  description = "Port of the LB listener"
}
