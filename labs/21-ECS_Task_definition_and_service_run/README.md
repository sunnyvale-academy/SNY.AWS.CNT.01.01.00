# ECS Task definition and service run

```console
$ terraform init && \
  terraform apply -auto-approve \
  -target=aws_ecs_task_definition.service \
  -target=aws_ecs_service.service-run
```