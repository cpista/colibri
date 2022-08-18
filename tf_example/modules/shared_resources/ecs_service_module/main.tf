module "platform_ecs_lb" {
  source = "../platform_ecs_cluster_module"

  app_lb_name           = var.app_lb_name
  lb_sg_name            = var.lb_sg_name
  ecs_name              = var.ecs_name
  domains_name          = var.domains_name
  vpc_id                = var.vpc_id
  app_name              = var.app_name
  app_environment       = var.app_environment
  container_environment = var.container_environment
  container_port        = var.container_port
}

module "ecs_task" {
  source = "../ecs_task_module"

  container_image       = var.container_image
  ecs_name              = var.ecs_name
  domains_name          = var.domains_name
  vpc_id                = var.vpc_id
  app_name              = var.app_name
  app_environment       = var.app_environment
  container_environment = var.container_environment
  container_port        = var.container_port
  ecs_task_exec_ecr     = module.ecr_repo.ecr_repo_arn
  ecr_url               = module.ecr_repo.ecr_repo_url
}

module "ecr_repo" {
  source = "../ecr_module"

  task_app_environment = module.ecs_task.app_environment
  task_app_name        = module.ecs_task.app_name
}


resource "aws_ecs_service" "main" {
  name                               = "${module.ecs_task.app_name}-service-${module.ecs_task.app_environment}"
  cluster                            = module.platform_ecs_lb.ecs_cluster_id
  task_definition                    = module.ecs_task.task_def_arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [module.ecs_task.ecs_task_sg_id]
    subnets          = [module.platform_ecs_lb.private_subnet_1, module.platform_ecs_lb.private_subnet_2]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_cluster_group.arn
    container_name   = module.ecs_task.container_name
    container_port   = module.ecs_task.container_port
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  depends_on = [module.platform_ecs_lb.ecs_cluster_id]
}

resource "aws_lb_target_group" "ecs_cluster_group" {
  name        = var.target_gr_name
  port        = module.ecs_task.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.platform_ecs_lb.vpc_id
  health_check {
    path                = "/"
    port                = 8000
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200" # has to be HTTP 200 or fails
  }

  tags = {
    Name        = "${module.ecs_task.app_name}-lb-tg"
    Environment = module.ecs_task.app_environment
  }
}

resource "aws_lb_listener" "app-lb-listener" {
  load_balancer_arn = module.platform_ecs_lb.load_balancer_arn
  port              = var.lb_listener
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_cluster_group.arn
  }
  depends_on = [
    aws_lb_target_group.ecs_cluster_group
  ]
}