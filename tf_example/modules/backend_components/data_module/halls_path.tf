resource "aws_api_gateway_resource" "assets_api_resource_halls" {
  parent_id   = aws_api_gateway_rest_api.assets_api.root_resource_id
  path_part   = var.resource_path_halls
  rest_api_id = aws_api_gateway_rest_api.assets_api.id
}

resource "aws_api_gateway_method" "assets_api_halls_post" {
  authorization = "NONE"
  http_method   = var.http_method[7]
  request_models = {"application/json" = aws_api_gateway_model.hall_creation_model.name}
  request_validator_id =  aws_api_gateway_request_validator.assets_api_validator.id
  resource_id   = aws_api_gateway_resource.assets_api_resource_halls.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_model.hall_creation_model
  ]
}

resource "aws_api_gateway_integration" "integration_halls_post" {
  http_method             = aws_api_gateway_method.assets_api_halls_post.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_halls.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_halls,
    aws_api_gateway_method.assets_api_halls_post
  ]
}

############ GET Method for all halls

resource "aws_api_gateway_method" "assets_api_halls_get" {
  authorization = "NONE"
  http_method   = var.http_method[2]
  resource_id   = aws_api_gateway_resource.assets_api_resource_halls.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
}

resource "aws_api_gateway_integration" "integration_halls_get" {
  http_method             = aws_api_gateway_method.assets_api_halls_get.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_halls.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_halls,
    aws_api_gateway_method.assets_api_halls_get
  ]
}

#########/halls/{id} GET method


resource "aws_api_gateway_resource" "assets_api_resource_halls_id_path" {
  parent_id   = aws_api_gateway_resource.assets_api_resource_halls.id
  path_part   = var.resource_path_id
  rest_api_id = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_halls
  ]
}

resource "aws_api_gateway_method" "assets_api_method_get_id_halls" {
  authorization = "NONE"
  http_method   = var.http_method[2]
  resource_id   = aws_api_gateway_resource.assets_api_resource_halls_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_halls_id_path
  ]
}

resource "aws_api_gateway_integration" "integration_get_id_halls" {
  http_method             = aws_api_gateway_method.assets_api_method_get_id_halls.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_halls_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_halls,
    aws_api_gateway_method.assets_api_method_get_id_halls,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_halls_id_path
  ]
}

#########/halls/{id} PUT method

resource "aws_api_gateway_method" "assets_api_method_put_id_halls" {
  authorization = "NONE"
  http_method   = var.http_method[8]
  resource_id   = aws_api_gateway_resource.assets_api_resource_halls_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  request_models = {"application/json" = aws_api_gateway_model.hall_creation_model.name}
  request_validator_id =  aws_api_gateway_request_validator.assets_api_validator.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_halls_id_path,
    aws_api_gateway_model.hall_creation_model
  ]
}

resource "aws_api_gateway_integration" "integration_put_id_halls" {
  http_method             = aws_api_gateway_method.assets_api_method_put_id_halls.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_halls_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_halls,
    aws_api_gateway_method.assets_api_method_put_id_halls,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_halls_id_path
  ]
}

#########/halls/{id} DELETE method

resource "aws_api_gateway_method" "assets_api_method_delete_id_halls" {
  authorization = "NONE"
  http_method   = var.http_method[1]
  resource_id   = aws_api_gateway_resource.assets_api_resource_halls_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_halls_id_path
  ]
}

resource "aws_api_gateway_integration" "integration_delete_id_halls" {
  http_method             = aws_api_gateway_method.assets_api_method_delete_id_halls.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_halls_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_halls,
    aws_api_gateway_method.assets_api_method_delete_id_halls,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_halls_id_path
  ]
}