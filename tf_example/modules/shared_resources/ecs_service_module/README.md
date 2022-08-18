<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr_repo"></a> [ecr\_repo](#module\_ecr\_repo) | ../ecr_module | n/a |
| <a name="module_ecs_task"></a> [ecs\_task](#module\_ecs\_task) | ../ecs_task_module | n/a |
| <a name="module_platform_ecs_lb"></a> [platform\_ecs\_lb](#module\_platform\_ecs\_lb) | ../platform_ecs_cluster_module | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_lb_listener.app-lb-listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.ecs_cluster_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_environment"></a> [app\_environment](#input\_app\_environment) | environment in which we deploy the app | `string` | n/a | yes |
| <a name="input_app_lb_name"></a> [app\_lb\_name](#input\_app\_lb\_name) | Name of the Load Balancer | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | name of the app that will run on ecs cluster | `string` | n/a | yes |
| <a name="input_container_environment"></a> [container\_environment](#input\_container\_environment) | environment of the containers | `string` | n/a | yes |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | name & tag of the image | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | port of the container and of the host | `number` | n/a | yes |
| <a name="input_domains_name"></a> [domains\_name](#input\_domains\_name) | n/a | `list(string)` | n/a | yes |
| <a name="input_ecs_name"></a> [ecs\_name](#input\_ecs\_name) | name of the ecs fargate cluster | `string` | n/a | yes |
| <a name="input_lb_listener"></a> [lb\_listener](#input\_lb\_listener) | Port of the LB listener | `number` | n/a | yes |
| <a name="input_lb_sg_name"></a> [lb\_sg\_name](#input\_lb\_sg\_name) | name of the sg for lb | `string` | n/a | yes |
| <a name="input_target_gr_name"></a> [target\_gr\_name](#input\_target\_gr\_name) | Name of the target group | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | id of the vpc that will be used to deploy lb and ecs cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_lb_listener_arn"></a> [aws\_lb\_listener\_arn](#output\_aws\_lb\_listener\_arn) | n/a |
| <a name="output_aws_lb_target_group_arn"></a> [aws\_lb\_target\_group\_arn](#output\_aws\_lb\_target\_group\_arn) | n/a |
| <a name="output_ecr_repo_url"></a> [ecr\_repo\_url](#output\_ecr\_repo\_url) | n/a |
| <a name="output_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#output\_ecs\_task\_role\_arn) | n/a |
| <a name="output_ecs_task_role_id"></a> [ecs\_task\_role\_id](#output\_ecs\_task\_role\_id) | n/a |
| <a name="output_ecs_task_role_name"></a> [ecs\_task\_role\_name](#output\_ecs\_task\_role\_name) | n/a |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | n/a |
| <a name="output_lb_dns"></a> [lb\_dns](#output\_lb\_dns) | n/a |
<!-- END_TF_DOCS -->