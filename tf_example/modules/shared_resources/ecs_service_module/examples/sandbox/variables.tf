variable "app_lb_name" {
  type        = string
  description = "Name of the Load Balancer"
  default     = "test-lb"
}

variable "target_gr_name" {
  type        = string
  description = "Name of the target group"
  default     = "ecs-fargate-cluster-test"
}

variable "lb_sg_name" {
  type        = string
  description = "name of the sg for lb"
  default     = "test-lb-sg"
}

variable "ecs_name" {
  type        = string
  description = "name of the ecs fargate cluster"
  default     = "test-ecs-cluster"
}

variable "domains_name" {
  type    = list(string)
  default = ["dev.example.com", "dev2.example.com"]
}

variable "vpc_id" {
  type        = string
  description = "id of the vpc that will be used to deploy lb and ecs cluster"
  default     = "vpc-0182a8a45e8caa282"
}

variable "app_name" {
  type        = string
  description = "name of the app that will run on ecs cluster"
  default     = "test-app"
}

variable "app_environment" {
  type        = string
  description = "environment in which we deploy the app"
  default     = "dev"
}

variable "container_environment" {
  type        = string
  description = "environment of the containers"
  default     = "test"
}

variable "container_port" {
  type        = number
  description = "port of the container and of the host"
  default     = 80
}

variable "container_image" {
  type        = string
  description = "name & tag of the image"
  default     = "nginx:latest"
}

variable "lb_listener" {
  type = number
  description = "Port of the LB listener"
  default = 80
}