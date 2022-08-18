# Configure the AWS Provider
provider "aws" {
  profile = "sw-nonprod"
  region  = "eu-central-1"
  default_tags {
    tags = {
      Environment = "sandbox"
      Owner       = "Terraform"
      Project     = "Assetsbackend"
    }
  }
}

module "assets_backend" {
  source = "../../"

  api_name                     = var.api_name
  api_method                   = var.api_method
  http_method                  = var.http_method
  resource_path_companies      = var.resource_path_companies
  resource_path_locations      = var.resource_path_locations
  resource_path_halls          = var.resource_path_halls
  resource_path_lines          = var.resource_path_lines
  resource_path_machines       = var.resource_path_machines
  resource_path_id             = var.resource_path_id
  integration_type             = var.integration_type
  stage_name                   = var.stage_name
  lambda_arch                  = var.lambda_arch
  lambda_function_name         = var.lambda_function_name
  lambda_handler               = var.lambda_handler
  lambda_policy_name           = var.lambda_policy_name
  source_path_archive          = var.source_path_archive
  source_path                  = var.source_path
  memory_size                  = var.memory_size
  runtime_code                 = var.runtime_code
  lambda_role                  = var.lambda_role
  name_authorizer              = var.name_authorizer
  lambda_authorizer_funct_name = var.lambda_authorizer_funct_name
  dynamodb_table_name          = var.dynamodb_table_name
  dynamodb_attributes          = var.dynamodb_attributes
  dynamodb_write_capacity      = var.dynamodb_write_capacity
  dynamodb_read_capacity       = var.dynamodb_read_capacity
  dynamodb_billing_mode        = var.dynamodb_billing_mode
  sqs_name                     = var.sqs_name
  env                          = var.env
}