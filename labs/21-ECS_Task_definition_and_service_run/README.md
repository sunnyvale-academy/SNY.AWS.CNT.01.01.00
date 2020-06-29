# ECS Task definition and service run

```console
$ terraform init && \
  terraform apply -auto-approve \
  -target=aws_ecs_task_definition.service \
  -target=aws_ecs_service.service-run \
  -target=aws_lb_target_group.ecs-target-group \
  -target=aws_lb.ecs-lb \
  -target=aws_lb_listener.front_end \
  -target=aws_security_group.lb_sg \
  -target=aws_security_group_rule.allow_http \
  -target=aws_security_group_rule.allow_egress_all
```