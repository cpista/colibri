variable "api_name" {
  type        = string
  description = "Name of the API"
}

variable "env" {
  type = string
  default = "sandbox"
}

variable "api_method" {
  type        = string
  description = "Method type of the API"
}

variable "http_method" {
  type        = list(any)
  description = "Method of the http request"
  default     = ["ANY", "DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "HOST", "POST", "PUT"]
}

variable "resource_path_companies" {
  type        = string
  description = "Resource path for API"
}

variable "resource_path_locations" {
  type        = string
  description = "Resource path for API"
}

variable "resource_path_halls" {
  type        = string
  description = "Resource path for API"
}

variable "resource_path_lines" {
  type        = string
  description = "Resource path for API"
}

variable "resource_path_machines" {
  type        = string
  description = "Resource path for API"
}

variable "resource_path_id" {
  type        = string
  description = "Resource path for API"
}

variable "integration_type" {
  type        = string
  description = "API Integration type of method"
}

variable "stage_name" {
  type        = string
  description = "First stage of the API"
}

variable "lambda_arch" {
  type        = list(any)
  description = "Architecture of the Lambda"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the lambda function"
}

variable "lambda_handler" {
  type        = string
  description = "Name of the script and name of the method that calls your lambda"
}

variable "lambda_policy_name" {
  type        = string
  description = "Name of the lambda policy"
}

variable "source_path_archive" {
  type        = string
  description = "Source code of the lambda"
}

variable "source_path" {
  type        = string
  description = "Source code of the lambda"
}

variable "memory_size" {
  type        = number
  description = "Memory size of the lambda"
}

variable "runtime_code" {
  type        = string
  description = "Runtime code exec of the lambda"
}

variable "lambda_role" {
  type        = string
  description = "Name of the iam role"
}

variable "name_authorizer" {
  type        = string
  description = "Name of the API authorizer"
}

variable "lambda_authorizer_funct_name" {
  type        = string
  description = "Name of the existing lambda authorizer"
}

variable "dynamodb_table_name" {
  type        = string
  description = "Name of the table"
}

variable "dynamodb_attributes" {
  description = "Atributes of the table"
}

variable "dynamodb_write_capacity" {
  type        = number
  description = "Write capacity of the dynamodb table"
}

variable "dynamodb_read_capacity" {
  type        = number
  description = "Read capacity of the dynamo db table"
}

variable "dynamodb_billing_mode" {
  type        = string
  description = "Controls how you are charged for read and write throughput and how you manage capacity"
}

variable "sqs_name" {
  type        = string
  description = "Name of the SQS"
}