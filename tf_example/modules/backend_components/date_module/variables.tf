variable "table_name" {
  type        = string
  description = "Name of the table"
}

variable "database_name" {
  type        = string
  description = "Name of the Database"
}

variable "mutability_option" {
  type    = string
  default = "MUTABLE"
}

variable "task_app_env" {
  type = string
}

variable "task_app_name" {
  type = string
}

variable "target_gr_name" {
  type        = string
  description = "Name of the target group"
}

variable "lb_sg_name" {
  type        = string
  description = "name of the security-group for lb"
}

variable "ecs_name" {
  type        = string
  description = "name of the ecs fargate cluster"
}

variable "domains_name" {
  type        = list(string)
  description = "Name of the domains."
}

variable "vpc_id" {
  type        = string
  description = "id of the vpc that will be used to deploy lb and ecs cluster"
}

variable "app_name" {
  type        = string
  description = "name of the app that will run on ecs cluster"
}

variable "container_port" {
  type        = number
  description = "port of the container and of the host"
}

variable "container_image" {
  type        = string
  description = "name & tag of the image"
}

variable "app_environment" {
  type        = string
  description = "environment in which we deploy the app, {var.container_image}:latest"
}

variable "app_lb_name" {
  type        = string
  description = "Name of the Load Balancer"
}

variable "container_environment" {
  type        = string
  description = "environment of the containers"
}

variable "lb_listener" {
  type        = number
  description = "Port of the lb listener"
}

variable "http_method_choose" {
  description = "Value of the Method"
}

variable "resource_path1" {
  type        = string
  description = "Path of the resource"
  default     = "populate"
}

variable "resource_path2" {
  type        = string
  description = "Path of the resource"
  default     = "query"
}

variable "resource_path3" {
  type        = string
  description = "Path of the resource"
  default     = "{hostname}"
}

variable "stage_name" {
  type        = string
  description = "Name of the Stage"
}

variable "stage_description" {
  type        = string
  description = "Description of the stage"
}

variable "function_name_lambda" {
  type        = string
  description = "Name of the Lambda Function"
}

variable "head_authorizer_api" {
  type        = string
  description = "The source of the identity in an incoming request"
}

variable "name_authorizer" {
  type        = string
  description = "Name of the authorizer"
}

variable "runtime_lambda" {
  type        = string
  description = "Version and type of programming language available"
  default     = "python3.8"
}

variable "architecture_lambda" {
  type        = string
  description = "The architecture of the lambda"
  default     = "x86_64"
}


variable "lambda_code_path" {
  type        = string
  description = "path to lambda code"
}

