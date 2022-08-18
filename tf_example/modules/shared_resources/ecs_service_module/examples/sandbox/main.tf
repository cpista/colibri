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

module "ecs_service" {
  source = "../../"

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

