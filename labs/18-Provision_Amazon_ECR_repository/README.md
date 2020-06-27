# Provision Amazon ECR repository

## Prerequisites

- Having installed Terraform utility [download here](https://www.terraform.io/downloads.html)

- Having completed the S3 part in [lab 17](../17-Provision_Amazon_ECS_cluster/README.md)

## Provision Amazon ECR repository


```console
$ terraform init && \
  terraform apply --target=aws_ecr_repository.ecr-repository -auto-approve  
...
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```