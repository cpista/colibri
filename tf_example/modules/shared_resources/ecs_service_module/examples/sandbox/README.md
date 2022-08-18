<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_environment"></a> [app\_environment](#input\_app\_environment) | environment in which we deploy the app | `string` | `"dev"` | no |
| <a name="input_app_lb_name"></a> [app\_lb\_name](#input\_app\_lb\_name) | Name of the Load Balancer | `string` | `"test-lb"` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | name of the app that will run on ecs cluster | `string` | `"test-app"` | no |
| <a name="input_container_environment"></a> [container\_environment](#input\_container\_environment) | environment of the containers | `string` | `"test"` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | name & tag of the image | `string` | `"nginx:latest"` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | port of the container and of the host | `number` | `80` | no |
| <a name="input_domains_name"></a> [domains\_name](#input\_domains\_name) | n/a | `list(string)` | <pre>[<br>  "dev.example.com",<br>  "dev2.example.com"<br>]</pre> | no |
| <a name="input_ecs_name"></a> [ecs\_name](#input\_ecs\_name) | name of the ecs fargate cluster | `string` | `"test-ecs-cluster"` | no |
| <a name="input_lb_listener"></a> [lb\_listener](#input\_lb\_listener) | Port of the LB listener | `number` | `80` | no |
| <a name="input_lb_sg_name"></a> [lb\_sg\_name](#input\_lb\_sg\_name) | name of the sg for lb | `string` | `"test-lb-sg"` | no |
| <a name="input_target_gr_name"></a> [target\_gr\_name](#input\_target\_gr\_name) | Name of the target group | `string` | `"ecs-fargate-cluster-test"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | id of the vpc that will be used to deploy lb and ecs cluster | `string` | `"vpc-0182a8a45e8caa282"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_lb_listener_arn"></a> [aws\_lb\_listener\_arn](#output\_aws\_lb\_listener\_arn) | n/a |
| <a name="output_aws_lb_target_group_arn"></a> [aws\_lb\_target\_group\_arn](#output\_aws\_lb\_target\_group\_arn) | n/a |
| <a name="output_ecr_repo_url"></a> [ecr\_repo\_url](#output\_ecr\_repo\_url) | n/a |
<!-- END_TF_DOCS -->