

resource "aws_api_gateway_rest_api" "assets_api" {
  name        = local.api_name
  description = "Assets_backend_for_sandbox"
}

resource "aws_api_gateway_deployment" "assets_api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.assets_api.id
  depends_on = [
    aws_api_gateway_integration.integration_companies_post,
    aws_api_gateway_integration.integration_companies_get,
    aws_api_gateway_resource.assets_api_resource_companies_id_path,
    aws_api_gateway_integration.integration_get_id_companies,
    aws_api_gateway_integration.integration_put_id_companies,
    aws_api_gateway_integration.integration_delete_id_companies,
    aws_api_gateway_integration.integration_locations_post,
    aws_api_gateway_integration.integration_locations_get,
    aws_api_gateway_resource.assets_api_resource_locations_id_path,
    aws_api_gateway_integration.integration_get_id_locations,
    aws_api_gateway_integration.integration_put_id_locations,
    aws_api_gateway_integration.integration_delete_id_locations,
    aws_api_gateway_integration.integration_halls_post,
    aws_api_gateway_integration.integration_halls_get,
    aws_api_gateway_resource.assets_api_resource_halls_id_path,
    aws_api_gateway_integration.integration_get_id_halls,
    aws_api_gateway_integration.integration_put_id_halls,
    aws_api_gateway_integration.integration_delete_id_halls,
    aws_api_gateway_integration.integration_lines_post,
    aws_api_gateway_integration.integration_lines_get,
    aws_api_gateway_resource.assets_api_resource_lines_id_path,
    aws_api_gateway_integration.integration_get_id_lines,
    aws_api_gateway_integration.integration_put_id_lines,
    aws_api_gateway_integration.integration_delete_id_lines,
    aws_api_gateway_integration.integration_machines_post,
    aws_api_gateway_integration.integration_machines_get,
    aws_api_gateway_resource.assets_api_resource_machines_id_path,
    aws_api_gateway_integration.integration_get_id_machines,
    aws_api_gateway_integration.integration_put_id_machines,
    aws_api_gateway_integration.integration_delete_id_machines
  ]
}

resource "aws_api_gateway_stage" "assets_api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.assets_api.id
  deployment_id = aws_api_gateway_deployment.assets_api_deploy.id
  stage_name    = local.stage_name
  description   = "first stage of assets_api deployment"
}

resource "aws_api_gateway_request_validator" "assets_api_validator" {
  name                        = "Assets_api_validator"
  rest_api_id                 = aws_api_gateway_rest_api.assets_api.id
  validate_request_body       = true
  validate_request_parameters = true
}
