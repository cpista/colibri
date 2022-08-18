resource "aws_api_gateway_resource" "assets_api_resource_locations" {
  parent_id   = aws_api_gateway_rest_api.assets_api.root_resource_id
  path_part   = var.resource_path_locations
  rest_api_id = aws_api_gateway_rest_api.assets_api.id
}

resource "aws_api_gateway_method" "assets_api_locations_post" {
  authorization = "NONE"
  http_method   = var.http_method[7]
  request_models = {"application/json" = aws_api_gateway_model.location_creation_model.name}
  request_validator_id =  aws_api_gateway_request_validator.assets_api_validator.id
  resource_id   = aws_api_gateway_resource.assets_api_resource_locations.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_model.location_creation_model
  ]
}

resource "aws_api_gateway_integration" "integration_locations_post" {
  http_method             = aws_api_gateway_method.assets_api_locations_post.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_locations.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_locations,
    aws_api_gateway_method.assets_api_locations_post
  ]
}

############ GET Method for all locations

resource "aws_api_gateway_method" "assets_api_locations_get" {
  authorization = "NONE"
  http_method   = var.http_method[2]
  resource_id   = aws_api_gateway_resource.assets_api_resource_locations.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
}

resource "aws_api_gateway_integration" "integration_locations_get" {
  http_method             = aws_api_gateway_method.assets_api_locations_get.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_locations.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_locations,
    aws_api_gateway_method.assets_api_locations_get
  ]
}

#########/locations/{id} GET method


resource "aws_api_gateway_resource" "assets_api_resource_locations_id_path" {
  parent_id   = aws_api_gateway_resource.assets_api_resource_locations.id
  path_part   = var.resource_path_id
  rest_api_id = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_locations
  ]
}

resource "aws_api_gateway_method" "assets_api_method_get_id_locations" {
  authorization = "NONE"
  http_method   = var.http_method[2]
  resource_id   = aws_api_gateway_resource.assets_api_resource_locations_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_locations_id_path
  ]
}

resource "aws_api_gateway_integration" "integration_get_id_locations" {
  http_method             = aws_api_gateway_method.assets_api_method_get_id_locations.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_locations_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_locations,
    aws_api_gateway_method.assets_api_method_get_id_locations,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_locations_id_path
  ]
}

#########/locations/{id} PUT method

resource "aws_api_gateway_method" "assets_api_method_put_id_locations" {
  authorization = "NONE"
  http_method   = var.http_method[8]
  resource_id   = aws_api_gateway_resource.assets_api_resource_locations_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  request_models = {"application/json" = aws_api_gateway_model.location_creation_model.name}
  request_validator_id =  aws_api_gateway_request_validator.assets_api_validator.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_locations_id_path,
    aws_api_gateway_model.location_creation_model
  ]
}

resource "aws_api_gateway_integration" "integration_put_id_locations" {
  http_method             = aws_api_gateway_method.assets_api_method_put_id_locations.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_locations_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_locations,
    aws_api_gateway_method.assets_api_method_put_id_locations,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_locations_id_path
  ]
}

#########/locations/{id} DELETE method

resource "aws_api_gateway_method" "assets_api_method_delete_id_locations" {
  authorization = "NONE"
  http_method   = var.http_method[1]
  resource_id   = aws_api_gateway_resource.assets_api_resource_locations_id_path.id
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_locations_id_path
  ]
}

resource "aws_api_gateway_integration" "integration_delete_id_locations" {
  http_method             = aws_api_gateway_method.assets_api_method_delete_id_locations.http_method
  resource_id             = aws_api_gateway_resource.assets_api_resource_locations_id_path.id
  rest_api_id             = aws_api_gateway_rest_api.assets_api.id
  uri                     = aws_lambda_function.assets_api_lambda.invoke_arn
  type                    = var.integration_type
  integration_http_method = "POST"
  depends_on = [
    aws_api_gateway_resource.assets_api_resource_locations,
    aws_api_gateway_method.assets_api_method_delete_id_locations,
    aws_api_gateway_rest_api.assets_api,
    aws_api_gateway_resource.assets_api_resource_locations_id_path
  ]
}