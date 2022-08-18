variable "api_name" {
  type        = string
  description = "Name of the API"
  default     = "data_api_backend_testAPI"
}

variable "env" {
  type = string
  default = "sandbox"
}

variable "api_method" {
  type        = string
  description = "Method type of the API"
  default     = "ANY"
}

variable "http_method" {
  type        = list(any)
  description = "Method of the http request"
  default     = ["ANY", "DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "HOST", "POST", "PUT"]
}

variable "resource_path_companies" {
  type        = string
  description = "Resource path for API"
  default     = "companies"
}

variable "resource_path_locations" {
  type        = string
  description = "Resource path for API"
  default     = "locations"
}

variable "resource_path_halls" {
  type        = string
  description = "Resource path for API"
  default     = "halls"
}

variable "resource_path_lines" {
  type        = string
  description = "Resource path for API"
  default     = "lines"
}

variable "resource_path_machines" {
  type        = string
  description = "Resource path for API"
  default     = "machines"
}

variable "resource_path_id" {
  type        = string
  description = "Resource path for API"
  default     = "{id}"
}

variable "integration_type" {
  type        = string
  description = "API Integration type of method"
  default     = "AWS_PROXY"
}

variable "stage_name" {
  type        = string
  description = "First stage of the API"
  default     = "default"

}

variable "lambda_arch" {
  type        = list(any)
  description = "Architecture of the Lambda"
  default     = ["x86_64"]
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the lambda function"
  default     = "data_api_backend_test"

}

variable "lambda_handler" {
  type        = string
  description = "Name of the script and name of the method that calls your lambda"
  default     = "func.lambda_handler"

}

variable "lambda_policy_name" {
  type        = string
  description = "Name of the lambda policy"
  default     = "Lambda_data_backend_test"

}

variable "source_path_archive" {
  type        = string
  description = "Source code of the lambda"
  default     = "../data/lambda_code.zip"
}

variable "source_path" {
  type        = string
  description = "Source code of the lambda"
  default     = "../data/lambda_code"
}

variable "memory_size" {
  type        = number
  description = "Memory size of the lambda"
  default     = 128
}

variable "runtime_code" {
  type        = string
  description = "Runtime code exec of the lambda"
  default     = "python3.8"
}

variable "lambda_role" {
  type        = string
  description = "Name of the iam role"
  default     = "data_api_backend_testrole"

}

variable "name_authorizer" {
  type        = string
  description = "Name of the API authorizer"
  default     = "data_authorizer"
}

variable "lambda_authorizer_funct_name" {
  type        = string
  description = "Name of the existing lambda authorizer"
  default     = "cognito-lambda-authorizer"
}
variable "dynamodb_table_name" {
  type        = string
  description = "Name of the table"
  default     = "testing-data-table-tf"
}

variable "dynamodb_attributes" {
  description = "Atributes of the table"
  default = [
    {
      name = "parent"
      type = "S"
    },
    {
      name = "uri"
      type = "S"
    }
  ]
}

variable "dynamodb_write_capacity" {
  type        = number
  description = "Write capacity of the dynamodb table"
  default     = 10
}

variable "dynamodb_read_capacity" {
  type        = number
  description = "Read capacity of the dynamo db table"
  default     = 10
}

variable "dynamodb_billing_mode" {
  type        = string
  description = "Controls how you are charged for read and write throughput and how you manage capacity"
  default     = "PROVISIONED"
}

variable "sqs_name" {
  type        = string
  description = "Name of the SQS"
  default     = "terraform-example-queue"
}