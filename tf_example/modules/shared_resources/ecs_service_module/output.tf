output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.ecs_cluster_group.arn
}

output "aws_lb_listener_arn" {
  value = aws_lb_listener.app-lb-listener.arn
}

output "ecr_repo_url" {
  value = module.ecr_repo.ecr_repo_url
}

output "ecs_task_role_name" {
  value = module.ecs_task.ecs_task_role_name
}

output "ecs_task_role_id" {
  value = module.ecs_task.ecs_task_role_id
}

output "ecs_task_role_arn" {
  value = module.ecs_task.ecs_task_role_arn
}

output "lb_arn" {
  value = module.platform_ecs_lb.load_balancer_arn
}

output "lb_dns" {
  value = module.platform_ecs_lb.load_balancer_dns
}
