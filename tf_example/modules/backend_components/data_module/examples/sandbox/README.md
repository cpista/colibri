<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_assets_backend"></a> [assets\_backend](#module\_assets\_backend) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_method"></a> [api\_method](#input\_api\_method) | Method type of the API | `string` | `"ANY"` | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | Name of the API | `string` | `"assets_api_backend_testAPI"` | no |
| <a name="input_dynamodb_attributes"></a> [dynamodb\_attributes](#input\_dynamodb\_attributes) | Atributes of the table | `list` | <pre>[<br>  {<br>    "name": "IotMachine",<br>    "type": "S"<br>  },<br>  {<br>    "name": "NumberOfRequest",<br>    "type": "S"<br>  }<br>]</pre> | no |
| <a name="input_dynamodb_billing_mode"></a> [dynamodb\_billing\_mode](#input\_dynamodb\_billing\_mode) | Controls how you are charged for read and write throughput and how you manage capacity | `string` | `"PROVISIONED"` | no |
| <a name="input_dynamodb_read_capacity"></a> [dynamodb\_read\_capacity](#input\_dynamodb\_read\_capacity) | Read capacity of the dynamo db table | `number` | `10` | no |
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | Name of the table | `string` | `"testing-assets-table-tf"` | no |
| <a name="input_dynamodb_write_capacity"></a> [dynamodb\_write\_capacity](#input\_dynamodb\_write\_capacity) | Write capacity of the dynamodb table | `number` | `10` | no |
| <a name="input_http_method1"></a> [http\_method1](#input\_http\_method1) | Method of the http request | `string` | `"PUT"` | no |
| <a name="input_http_method2"></a> [http\_method2](#input\_http\_method2) | Method of the http request | `string` | `"GET"` | no |
| <a name="input_integration_type"></a> [integration\_type](#input\_integration\_type) | API Integration type of method | `string` | `"AWS_PROXY"` | no |
| <a name="input_lambda_arch"></a> [lambda\_arch](#input\_lambda\_arch) | Architecture of the Lambda | `list(any)` | <pre>[<br>  "x86_64"<br>]</pre> | no |
| <a name="input_lambda_authorizer_funct_name"></a> [lambda\_authorizer\_funct\_name](#input\_lambda\_authorizer\_funct\_name) | Name of the existing lambda authorizer | `string` | `"cognito-lambda-authorizer"` | no |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | Name of the lambda function | `string` | `"assets_api_backend_test"` | no |
| <a name="input_lambda_handler"></a> [lambda\_handler](#input\_lambda\_handler) | Name of the script and name of the method that calls your lambda | `string` | `"test_lambda.lambda_handler"` | no |
| <a name="input_lambda_policy_name"></a> [lambda\_policy\_name](#input\_lambda\_policy\_name) | Name of the lambda policy | `string` | `"Lambda_assets_backend_test"` | no |
| <a name="input_lambda_role"></a> [lambda\_role](#input\_lambda\_role) | Name of the iam role | `string` | `"assets_api_backend_testrole"` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory size of the lambda | `number` | `128` | no |
| <a name="input_name_authorizer"></a> [name\_authorizer](#input\_name\_authorizer) | Name of the API authorizer | `string` | `"assets_authorizer"` | no |
| <a name="input_resource_path1"></a> [resource\_path1](#input\_resource\_path1) | Resource path for API | `string` | `"insert_data"` | no |
| <a name="input_resource_path2"></a> [resource\_path2](#input\_resource\_path2) | Resource path for API | `string` | `"query"` | no |
| <a name="input_runtime_code"></a> [runtime\_code](#input\_runtime\_code) | Runtime code exec of the lambda | `string` | `"python3.8"` | no |
| <a name="input_source_path"></a> [source\_path](#input\_source\_path) | Source code of the lambda | `string` | `"../../test_lambda.py"` | no |
| <a name="input_source_path_archive"></a> [source\_path\_archive](#input\_source\_path\_archive) | Source code of the lambda | `string` | `"../../test_lambda.py.zip"` | no |
| <a name="input_sqs_name"></a> [sqs\_name](#input\_sqs\_name) | Name of the SQS | `string` | `"terraform-example-queue"` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | First stage of the API | `string` | `"default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway_arn"></a> [api\_gateway\_arn](#output\_api\_gateway\_arn) | n/a |
| <a name="output_api_gateway_id"></a> [api\_gateway\_id](#output\_api\_gateway\_id) | n/a |
| <a name="output_assets_sqs_arn"></a> [assets\_sqs\_arn](#output\_assets\_sqs\_arn) | n/a |
| <a name="output_assets_sqs_queue_url"></a> [assets\_sqs\_queue\_url](#output\_assets\_sqs\_queue\_url) | n/a |
| <a name="output_dynamo_arn"></a> [dynamo\_arn](#output\_dynamo\_arn) | n/a |
| <a name="output_iam_lambda_arn"></a> [iam\_lambda\_arn](#output\_iam\_lambda\_arn) | n/a |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | n/a |
<!-- END_TF_DOCS -->