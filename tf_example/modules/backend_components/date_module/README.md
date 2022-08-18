<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.75.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | ../../shared_resources/ecs_service_module/ | n/a |
| <a name="module_timestream_db"></a> [timestream\_db](#module\_timestream\_db) | ../timestream_module/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_authorizer.timeseries_authorizer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_authorizer) | resource |
| [aws_api_gateway_deployment.timeseries_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.integration_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.integration_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration_response.response1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response) | resource |
| [aws_api_gateway_integration_response.response2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response) | resource |
| [aws_api_gateway_method.timeseries_method1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.timeseries_method2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_response.response_2001](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_method_response.response_2002](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_resource.timeseries_resource1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.timeseries_resource2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.timeseries_resource3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.timeseries_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.timeseries_stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_task_role_full](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.authorizer_timeseries_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_environment"></a> [app\_environment](#input\_app\_environment) | environment in which we deploy the app, {var.container\_image}:latest | `string` | n/a | yes |
| <a name="input_app_lb_name"></a> [app\_lb\_name](#input\_app\_lb\_name) | Name of the Load Balancer | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | name of the app that will run on ecs cluster | `string` | n/a | yes |
| <a name="input_architecture_lambda"></a> [architecture\_lambda](#input\_architecture\_lambda) | The architecture of the lambda | `string` | `"x86_64"` | no |
| <a name="input_container_environment"></a> [container\_environment](#input\_container\_environment) | environment of the containers | `string` | n/a | yes |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | name & tag of the image | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | port of the container and of the host | `number` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name of the Database | `string` | n/a | yes |
| <a name="input_domains_name"></a> [domains\_name](#input\_domains\_name) | Name of the domains. | `list(string)` | n/a | yes |
| <a name="input_ecs_name"></a> [ecs\_name](#input\_ecs\_name) | name of the ecs fargate cluster | `string` | n/a | yes |
| <a name="input_function_name_lambda"></a> [function\_name\_lambda](#input\_function\_name\_lambda) | Name of the Lambda Function | `string` | n/a | yes |
| <a name="input_head_authorizer_api"></a> [head\_authorizer\_api](#input\_head\_authorizer\_api) | The source of the identity in an incoming request | `string` | n/a | yes |
| <a name="input_http_method_choose"></a> [http\_method\_choose](#input\_http\_method\_choose) | Value of the Method | `any` | n/a | yes |
| <a name="input_lambda_code_path"></a> [lambda\_code\_path](#input\_lambda\_code\_path) | path to lambda code | `string` | n/a | yes |
| <a name="input_lb_listener"></a> [lb\_listener](#input\_lb\_listener) | Port of the lb listener | `number` | n/a | yes |
| <a name="input_lb_sg_name"></a> [lb\_sg\_name](#input\_lb\_sg\_name) | name of the security-group for lb | `string` | n/a | yes |
| <a name="input_mutability_option"></a> [mutability\_option](#input\_mutability\_option) | n/a | `string` | `"MUTABLE"` | no |
| <a name="input_name_authorizer"></a> [name\_authorizer](#input\_name\_authorizer) | Name of the authorizer | `string` | n/a | yes |
| <a name="input_resource_path1"></a> [resource\_path1](#input\_resource\_path1) | Path of the resource | `string` | `"populate"` | no |
| <a name="input_resource_path2"></a> [resource\_path2](#input\_resource\_path2) | Path of the resource | `string` | `"query"` | no |
| <a name="input_resource_path3"></a> [resource\_path3](#input\_resource\_path3) | Path of the resource | `string` | `"{hostname}"` | no |
| <a name="input_runtime_lambda"></a> [runtime\_lambda](#input\_runtime\_lambda) | Version and type of programming language available | `string` | `"python3.8"` | no |
| <a name="input_stage_description"></a> [stage\_description](#input\_stage\_description) | Description of the stage | `string` | n/a | yes |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | Name of the Stage | `string` | n/a | yes |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Name of the table | `string` | n/a | yes |
| <a name="input_target_gr_name"></a> [target\_gr\_name](#input\_target\_gr\_name) | Name of the target group | `string` | n/a | yes |
| <a name="input_task_app_env"></a> [task\_app\_env](#input\_task\_app\_env) | n/a | `string` | n/a | yes |
| <a name="input_task_app_name"></a> [task\_app\_name](#input\_task\_app\_name) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | id of the vpc that will be used to deploy lb and ecs cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway_arn"></a> [api\_gateway\_arn](#output\_api\_gateway\_arn) | n/a |
| <a name="output_api_gateway_deploy_arn"></a> [api\_gateway\_deploy\_arn](#output\_api\_gateway\_deploy\_arn) | n/a |
| <a name="output_api_gateway_id"></a> [api\_gateway\_id](#output\_api\_gateway\_id) | n/a |
| <a name="output_api_gateway_stage_arn"></a> [api\_gateway\_stage\_arn](#output\_api\_gateway\_stage\_arn) | n/a |
| <a name="output_iam_lambda_arn"></a> [iam\_lambda\_arn](#output\_iam\_lambda\_arn) | n/a |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | n/a |
<!-- END_TF_DOCS -->