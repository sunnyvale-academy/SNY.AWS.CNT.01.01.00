# ECS Task definition and service run

Insert the VPC id in terraform.tfvas before running this lab.

```console
$ terraform init && \
  terraform apply \
  -target=aws_ecs_task_definition.friendly-hello \
  -target=aws_ecs_service.service-run \
  -target=aws_ecs_task_definition.redis \
  -target=aws_ecs_service.redis-service-run \
  -target=aws_lb_target_group.ecs-target-group \
  -target=aws_lb.ecs-lb \
  -target=aws_lb_listener.front_end \
  -target=aws_security_group.lb_sg \
  -target=aws_security_group_rule.allow_http \
  -target=aws_security_group_rule.allow_egress_all
```