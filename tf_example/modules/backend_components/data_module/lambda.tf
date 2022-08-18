data "archive_file" "lambda_my_function" {
  type = "zip"
  #source_file      = var.source_path
  source_dir       = var.source_path
  output_file_mode = "0666"
  output_path      = var.source_path_archive
}

resource "aws_lambda_function" "assets_api_lambda" {
  architectures = var.lambda_arch
  description   = "Lambda for assets backend tf."
  function_name = local.lambda_function_name
  handler       = var.lambda_handler
  filename      = var.source_path_archive
  memory_size   = var.memory_size
  role          = aws_iam_role.lambda_assets_api_role.arn
  runtime       = var.runtime_code
  timeout       = 300
  environment {
    variables = {
      sqs_url       = aws_sqs_queue.terraform_queue.url
      sns_topic_arn = "arn:aws:sns:eu-central-1:444600356670:testing_assets"
    }
  }
  depends_on = [
    aws_sqs_queue.terraform_queue,
    data.archive_file.lambda_my_function
  ]
}

resource "aws_iam_role" "lambda_assets_api_role" {
  name = local.lambda_role
  path = "/servicerole/"
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


# To be changed to few permission when deployed for non prod and prod

resource "aws_iam_policy" "assets_api_lambda_policy" {
  name   = local.lambda_policy_name
  path   = "/servicerole/"
  policy = <<EOF
{
  "Version": "2012-10-17",
   "Statement": [
    {
      "Sid": "ReadWriteTable",
      "Effect": "Allow",
      "Action": [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
      ],
      "Resource": "${aws_dynamodb_table.dynamodb_table.arn}"
  },
  {
      "Sid": "Publishtosns",
      "Effect": "Allow",
      "Action": [
          "sns:GetEndpointAttributes",
          "sns:GetPlatformApplicationAttributes",
          "sns:GetSubscriptionAttributes",
          "sns:Publish"
      ],
      "Resource": "*"
  },
  {
      "Sid": "GetStreamRecords",
      "Effect": "Allow",
      "Action": "dynamodb:GetRecords",
      "Resource": "${aws_dynamodb_table.dynamodb_table.arn}"
  },
  {
      "Sid": "WriteLogStreamsAndGroups",
      "Effect": "Allow",
      "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
      ],
      "Resource": "*"
  },
  {
      "Sid": "CreateLogGroup",
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "*"
  }
]
}
EOF
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.assets_api.execution_arn}/*"
  depends_on = [
    aws_lambda_function.assets_api_lambda
  ]
}

resource "aws_iam_policy_attachment" "attach_policy" {
  name       = "policy_attachment"
  roles      = [aws_iam_role.lambda_assets_api_role.id]
  policy_arn = aws_iam_policy.assets_api_lambda_policy.arn
}

