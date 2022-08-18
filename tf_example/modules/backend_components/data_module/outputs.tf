output "api_gateway_arn" {
  value = aws_api_gateway_rest_api.assets_api.arn
}

output "iam_lambda_arn" {
  value = aws_iam_role.lambda_assets_api_role.arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.assets_api_lambda.arn
}


output "api_gateway_id" {
  value = aws_api_gateway_rest_api.assets_api.id
}

output "assets_sqs_queue_url" {
  value = aws_sqs_queue.terraform_queue.url
}

output "dynamo_arn" {
  value = aws_dynamodb_table.dynamodb_table.arn
}

output "assets_sqs_arn" {
  value = aws_sqs_queue.terraform_queue.arn
}