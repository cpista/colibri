output "aws_lb_target_group_arn" {
  value = module.ecs_service.aws_lb_target_group_arn
}

output "aws_lb_listener_arn" {
  value = module.ecs_service.aws_lb_listener_arn
}

output "ecr_repo_url" {
  value = module.ecs_service.ecr_repo_url
}