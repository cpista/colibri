resource "aws_api_gateway_rest_api" "timeseries_api" {
  name = "Test API"
  tags = {}
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_integration" "integration_1" {
  http_method             = "GET"
  resource_id             = aws_api_gateway_resource.timeseries_resource1.id
  rest_api_id             = aws_api_gateway_rest_api.timeseries_api.id
  type                    = "HTTP"
  integration_http_method = "GET"
  uri                     = "http://${module.ecs_service.lb_dns}/populate"
  depends_on = [
    module.ecs_service.lb_arn,
    aws_api_gateway_resource.timeseries_resource1,

  ]
}

resource "aws_api_gateway_integration" "integration_2" {
  http_method             = "GET"
  resource_id             = aws_api_gateway_resource.timeseries_resource3.id
  rest_api_id             = aws_api_gateway_rest_api.timeseries_api.id
  type                    = "HTTP"
  integration_http_method = "GET"
  uri                     = "http://${module.ecs_service.lb_dns}/query/{hostname}"
  depends_on = [
    module.ecs_service.lb_arn,
    aws_api_gateway_resource.timeseries_resource2
  ]
  request_parameters = {
    "integration.request.path.hostname" = "method.request.path.hostname"
  }
}

resource "aws_api_gateway_deployment" "timeseries_deploy" {
  rest_api_id = aws_api_gateway_rest_api.timeseries_api.id
  depends_on = [
    aws_api_gateway_method.timeseries_method1,
    aws_api_gateway_integration.integration_1,
    aws_api_gateway_integration.integration_2,
  ]
}

resource "aws_api_gateway_method" "timeseries_method1" {
  authorization        = "CUSTOM"
  authorizer_id        = aws_api_gateway_authorizer.timeseries_authorizer.id
  authorization_scopes = []
  http_method          = var.http_method_choose
  resource_id          = aws_api_gateway_resource.timeseries_resource1.id
  request_models       = {}
  request_parameters   = {}
  rest_api_id          = aws_api_gateway_rest_api.timeseries_api.id
}

resource "aws_api_gateway_method_response" "response_2001" {
  rest_api_id     = aws_api_gateway_rest_api.timeseries_api.id
  resource_id     = aws_api_gateway_resource.timeseries_resource1.id
  http_method     = aws_api_gateway_method.timeseries_method1.http_method
  status_code     = "200"
  response_models = {}
  depends_on = [
    aws_api_gateway_resource.timeseries_resource1,
  ]
}

resource "aws_api_gateway_integration_response" "response1" {
  rest_api_id = aws_api_gateway_rest_api.timeseries_api.id
  resource_id = aws_api_gateway_resource.timeseries_resource1.id
  http_method = var.http_method_choose
  status_code = aws_api_gateway_method_response.response_2001.status_code
  depends_on = [
    aws_api_gateway_method_response.response_2001,
    aws_api_gateway_method.timeseries_method1,
    aws_api_gateway_integration.integration_1,
  ]
}

resource "aws_api_gateway_integration_response" "response2" {
  rest_api_id         = aws_api_gateway_rest_api.timeseries_api.id
  resource_id         = aws_api_gateway_resource.timeseries_resource3.id
  http_method         = aws_api_gateway_method.timeseries_method2.http_method
  status_code         = aws_api_gateway_method_response.response_2002.status_code
  response_parameters = {}
  depends_on = [
    aws_api_gateway_method_response.response_2002,
    aws_api_gateway_method.timeseries_method2,
    aws_api_gateway_integration.integration_2,
  ]
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_resource" "timeseries_resource1" {
  parent_id   = aws_api_gateway_rest_api.timeseries_api.root_resource_id
  path_part   = var.resource_path1
  rest_api_id = aws_api_gateway_rest_api.timeseries_api.id
}

resource "aws_api_gateway_resource" "timeseries_resource2" {
  parent_id   = aws_api_gateway_rest_api.timeseries_api.root_resource_id
  path_part   = var.resource_path2
  rest_api_id = aws_api_gateway_rest_api.timeseries_api.id

}

resource "aws_api_gateway_resource" "timeseries_resource3" {
  parent_id   = aws_api_gateway_resource.timeseries_resource2.id
  path_part   = var.resource_path3
  rest_api_id = aws_api_gateway_rest_api.timeseries_api.id
}

resource "aws_api_gateway_method" "timeseries_method2" {
  authorization        = "CUSTOM"
  authorizer_id        = aws_api_gateway_authorizer.timeseries_authorizer.id
  authorization_scopes = []
  http_method          = var.http_method_choose
  resource_id          = aws_api_gateway_resource.timeseries_resource3.id
  request_models       = {}
  request_parameters = {
    "method.request.path.hostname" = true
  }
  rest_api_id = aws_api_gateway_rest_api.timeseries_api.id
}

resource "aws_api_gateway_method_response" "response_2002" {
  rest_api_id = aws_api_gateway_rest_api.timeseries_api.id
  resource_id = aws_api_gateway_resource.timeseries_resource3.id
  http_method = aws_api_gateway_method.timeseries_method2.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  depends_on = [
    aws_api_gateway_resource.timeseries_resource3,
  ]
}

resource "aws_api_gateway_stage" "timeseries_stage" {
  rest_api_id   = aws_api_gateway_rest_api.timeseries_api.id
  deployment_id = aws_api_gateway_deployment.timeseries_deploy.id
  stage_name    = var.stage_name
  description   = var.stage_description
  tags          = {}
  variables     = {}
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "Test-Authorizer-role-kzgmdx2v"
  path = "/service-role/"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_lambda_function" "authorizer_timeseries_lambda" {
  architectures = [var.architecture_lambda]
  description   = "Blueprint for API Gateway custom authorizers."
  function_name = var.function_name_lambda
  handler       = var.lambda_code_path
  filename      = var.lambda_code_path
  memory_size   = 256
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = var.runtime_lambda
  tags = {
    "lambda-console:blueprint" = "api-gateway-authorizer-python"
  }
  tags_all = {
    "lambda-console:blueprint" = "api-gateway-authorizer-python"
  }
  timeout = 5
}

resource "aws_api_gateway_authorizer" "timeseries_authorizer" {
  name                             = var.name_authorizer
  rest_api_id                      = aws_api_gateway_rest_api.timeseries_api.id
  authorizer_result_ttl_in_seconds = 0
  identity_source                  = "method.request.header.${var.head_authorizer_api}"
  authorizer_uri                   = aws_lambda_function.authorizer_timeseries_lambda.invoke_arn
}