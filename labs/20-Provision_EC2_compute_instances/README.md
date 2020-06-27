


```console
$ terraform init && \
  terraform apply -target=module.vpc \
  -target=aws_availability_zones.available \
  -target=aws_vpc.main -target=aws_ami.ecs \
  -target=aws_autoscaling_group.ecs_cluster_spot \
  -target=aws_autoscaling_policy.ecs_cluster_scale_policy \
  -target=aws_launch_configuration.ecs_config_launch_config_spot \
  -target=aws_security_group.sg_for_ec2_instances \
  -target=aws_security_group_rule.allow_ssh \
  -target=aws_security_group_rule.allow_http_in \
  -target=aws_security_group_rule.allow_https_in \
  -target=aws_security_group_rule.allow_egress_all \
  -auto-approve
```