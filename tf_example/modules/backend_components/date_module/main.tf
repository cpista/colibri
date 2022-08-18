terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = "tf-user-sw"
  region  = "eu-central-1"
}

module "timestream_db" {
  source = "../timestream_module/"

  table_name    = var.table_name
  database_name = var.database_name

}

module "ecs_service" {
  source = "../../shared_resources/ecs_service_module/"

  app_lb_name           = var.app_lb_name
  target_gr_name        = var.target_gr_name
  lb_sg_name            = var.lb_sg_name
  ecs_name              = var.ecs_name
  domains_name          = var.domains_name
  vpc_id                = var.vpc_id
  app_name              = var.app_name
  app_environment       = var.app_environment
  container_environment = var.container_environment
  container_port        = var.container_port
  container_image       = var.container_image
  lb_listener           = var.lb_listener
}


resource "aws_iam_role_policy_attachment" "ecs_task_role_full" {
  role       = module.ecs_service.ecs_task_role_id
  policy_arn = module.timestream_db.timestream_db_iam_policy_arn

}


