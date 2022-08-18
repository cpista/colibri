resource "aws_api_gateway_resource" "assets_api_resource_lines" {
  parent_id   = aws_api_gateway_rest_api.assets_api.root_resource_id
  path_part   = var.resource_path_lines
  rest_api_id = aws_api_gateway_rest_api.assets_api.id
}

resource "aws_api_gateway_method" "assets_api_lines_post" {
  authorization = "NONE"
  http_method   = var.http_method[7]
  request_models = {"application/json" = aws_api_gateway_model.line_creation_model.name}
  request_validator_id =  aws_api_gateway_request_validator.assets_api_validator.id
  resource_id   = aws_api_gateway_resource.assets_api_resource_lines.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_model.line_creation_model
  ]
}

resource "aws_api_gateway_integration" "integration_lines_post" {
  http_method             = aws_api_gateway_method.assets_api_lines_post.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_lines.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_lines,
    aws_api_gateway_method.assets_api_lines_post
  ]
}

############ GET Method for all lines

resource "aws_api_gateway_method" "assets_api_lines_get" {
  authorization = "NONE"
  http_method   = var.http_method[2]
  resource_id   = aws_api_gateway_resource.assets_api_resource_lines.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
}

resource "aws_api_gateway_integration" "integration_lines_get" {
  http_method             = aws_api_gateway_method.assets_api_lines_get.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_lines.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_lines,
    aws_api_gateway_method.assets_api_lines_get
  ]
}

#########/lines/{id} GET method


resource "aws_api_gateway_resource" "assets_api_resource_lines_id_path" {
  parent_id   = aws_api_gateway_resource.assets_api_resource_lines.id
  path_part   = var.resource_path_id
  rest_api_id = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_lines
  ]
}

resource "aws_api_gateway_method" "assets_api_method_get_id_lines" {
  authorization = "NONE"
  http_method   = var.http_method[2]
  resource_id   = aws_api_gateway_resource.assets_api_resource_lines_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_lines_id_path
  ]
}

resource "aws_api_gateway_integration" "integration_get_id_lines" {
  http_method             = aws_api_gateway_method.assets_api_method_get_id_lines.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_lines_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_lines,
    aws_api_gateway_method.assets_api_method_get_id_lines,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_lines_id_path
  ]
}

#########/lines/{id} PUT method

resource "aws_api_gateway_method" "assets_api_method_put_id_lines" {
  authorization = "NONE"
  http_method   = var.http_method[8]
  resource_id   = aws_api_gateway_resource.assets_api_resource_lines_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  request_models = {"application/json" = aws_api_gateway_model.line_creation_model.name}
  request_validator_id =  aws_api_gateway_request_validator.assets_api_validator.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_lines_id_path,
    aws_api_gateway_model.line_creation_model
  ]
}

resource "aws_api_gateway_integration" "integration_put_id_lines" {
  http_method             = aws_api_gateway_method.assets_api_method_put_id_lines.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_lines_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_lines,
    aws_api_gateway_method.assets_api_method_put_id_lines,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_lines_id_path
  ]
}

#########/lines/{id} DELETE method

resource "aws_api_gateway_method" "assets_api_method_delete_id_lines" {
  authorization = "NONE"
  http_method   = var.http_method[1]
  resource_id   = aws_api_gateway_resource.assets_api_resource_lines_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_lines_id_path
  ]
}

resource "aws_api_gateway_integration" "integration_delete_id_lines" {
  http_method             = aws_api_gateway_method.assets_api_method_delete_id_lines.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_lines_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_lines,
    aws_api_gateway_method.assets_api_method_delete_id_lines,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_lines_id_path
  ]
}