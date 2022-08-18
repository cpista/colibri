output "api_gateway_arn" {
  value = module.assets_backend.api_gateway_arn
}

output "iam_lambda_arn" {
  value = module.assets_backend.iam_lambda_arn
}

output "lambda_function_arn" {
  value = module.assets_backend.lambda_function_arn
}


output "api_gateway_id" {
  value = module.assets_backend.api_gateway_id
}

output "assets_sqs_queue_url" {
  value = module.assets_backend.assets_sqs_queue_url
}
output "dynamo_arn" {
  value = module.assets_backend.dynamo_arn
}

output "assets_sqs_arn" {
  value = module.assets_backend.assets_sqs_arn
}