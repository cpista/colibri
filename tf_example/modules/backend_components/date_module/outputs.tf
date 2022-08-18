output "api_gateway_arn" {
    value = aws_api_gateway_rest_api.timeseries_api.arn
}

output "api_gateway_deploy_arn" {
    value = aws_api_gateway_deployment.timeseries_deploy.execution_arn
}

output "api_gateway_stage_arn" {
    value = aws_api_gateway_stage.timeseries_stage.arn
}

output "iam_lambda_arn" {
    value = aws_iam_role.iam_for_lambda.arn
}

output "lambda_function_arn" {
    value = aws_lambda_function.authorizer_timeseries_lambda.arn
}


output "api_gateway_id" {
    value = aws_api_gateway_rest_api.timeseries_api.id
}
