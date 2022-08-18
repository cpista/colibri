resource "aws_api_gateway_resource" "assets_api_resource_companies" {
  parent_id   = aws_api_gateway_rest_api.assets_api.root_resource_id
  path_part   = var.resource_path_companies
  rest_api_id = aws_api_gateway_rest_api.assets_api.id
}

resource "aws_api_gateway_method" "assets_api_companies_post" {
  authorization = "NONE"
  http_method   = var.http_method[7]
  request_validator_id =  aws_api_gateway_request_validator.assets_api_validator.id
  request_models = {"application/json" = aws_api_gateway_model.company_creation_model.name}
  resource_id   = aws_api_gateway_resource.assets_api_resource_companies.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_model.company_creation_model
  ]
}

resource "aws_api_gateway_integration" "integration_companies_post" {
  http_method             = aws_api_gateway_method.assets_api_companies_post.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_companies.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
  integration_http_method = aws_api_gateway_method.assets_api_companies_post.http_method
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_companies,
    aws_api_gateway_method.assets_api_companies_post
  ]
}

############ GET Method for all companies

resource "aws_api_gateway_method" "assets_api_companies_get" {
  authorization = "NONE"
  http_method   = var.http_method[2]
  resource_id   = aws_api_gateway_resource.assets_api_resource_companies.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
}

resource "aws_api_gateway_integration" "integration_companies_get" {
  http_method             = aws_api_gateway_method.assets_api_companies_get.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_companies.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_companies,
    aws_api_gateway_method.assets_api_companies_get
  ]
}

#########/companies/{id} GET method


resource "aws_api_gateway_resource" "assets_api_resource_companies_id_path" {
  parent_id   = aws_api_gateway_resource.assets_api_resource_companies.id
  path_part   = var.resource_path_id
  rest_api_id = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_companies
  ]
}

resource "aws_api_gateway_method" "assets_api_method_get_id_companies" {
  authorization = "NONE"
  http_method   = var.http_method[2]
  resource_id   = aws_api_gateway_resource.assets_api_resource_companies_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_companies_id_path
  ]
}

resource "aws_api_gateway_integration" "integration_get_id_companies" {
  http_method             = aws_api_gateway_method.assets_api_method_get_id_companies.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_companies_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_companies,
    aws_api_gateway_method.assets_api_method_get_id_companies,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_companies_id_path
  ]
}

#########/companies/{id} PUT method

resource "aws_api_gateway_method" "assets_api_method_put_id_companies" {
  authorization = "NONE"
  http_method   = var.http_method[8]
  request_validator_id =  aws_api_gateway_request_validator.assets_api_validator.id
  request_models = {"application/json" = aws_api_gateway_model.company_creation_model.name}
  resource_id   = aws_api_gateway_resource.assets_api_resource_companies_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_companies_id_path,
    aws_api_gateway_model.company_creation_model
  ]
}

resource "aws_api_gateway_integration" "integration_put_id_companies" {
  http_method             = aws_api_gateway_method.assets_api_method_put_id_companies.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_companies_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_companies,
    aws_api_gateway_method.assets_api_method_put_id_companies,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_companies_id_path
  ]
}

#########/companies/{id} DELETE method

resource "aws_api_gateway_method" "assets_api_method_delete_id_companies" {
  authorization = "NONE"
  http_method   = var.http_method[1]
  resource_id   = aws_api_gateway_resource.assets_api_resource_companies_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_companies_id_path
  ]
}

resource "aws_api_gateway_integration" "integration_delete_id_companies" {
  http_method             = aws_api_gateway_method.assets_api_method_delete_id_companies.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_companies_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_companies,
    aws_api_gateway_method.assets_api_method_delete_id_companies,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_companies_id_path
  ]
}

